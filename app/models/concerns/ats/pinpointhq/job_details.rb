module Ats
  module Pinpointhq
    module JobDetails
      include ActionView::Helpers::NumberHelper
      include Constants

      def fetch_title_and_location(job_data)
        title = job_data['title']
        location_string = build_location_string(job_data)
        location = Standardizer::LocationStandardizer.new('').simple_standardize(location_string)
        [title, location]
      end

      def fetch_id(job_data)
        # TODO: fetch the individual api endpoint from job_id
        path = job_data['careers_url']
        result = path&.match(%r{recruitee.com/o/([a-z\-0-9]+)})
        result[1] if result
      end

      private

      def fetch_job_data(job)
        job_id = job.ats_job_id
        jobs = fetch_company_jobs(job.company.ats_identifier)
        data = jobs.find { |job_data| job_data['path'] == "/en/postings/#{job_id}" }

        return data if data

        # TODO: fix setup for when job posting is no longer live - at the moment will break the import

        p "Job with ID #{job.ats_job_id} is expired."
        job.live = false
        return nil
      end

      def job_url_api(_base_url, ats_identifier, _job_id)
        company = Company.find_by(ats_identifier:)
        company.url_ats_api
      end

      def job_details(job, data)
        job.assign_attributes(
          title: data['title'],
          description: build_description(data),
          salary: fetch_salary(data),
          employment_type: data['employment_type'].gsub('_', '-').capitalize,
          non_geocoded_location_string: build_location_string(data),
          department: data.dig('job', 'department', 'name'),
          requirements: data['skills_knowledge_requirements'],
          responsibilities: data['key_responsibilities'],
          benefits: data['benefits'],
          posting_url: data['url'],
          deadline: (Date.parse(data['deadline_at']) if data['deadline_at']),
          remote: data['workplace_type'] == 'remote',
          hybrid: data['workplace_type'] == 'hybrid'
        )
      end

      def build_description(data)
        [
          data['description'],
          ("<h2>#{data['key_responsibilities_header']}</h2>" if data['key_responsibilities_header']),
          data['key_responsibilities'],
          ("<h2>#{data['skills_knowledge_expertise_header']}</h2>" if data['skills_knowledge_expertise_header']),
          data['skills_knowledge_expertise'],
          ("<h2>#{data['benefits_header']}</h2>" if data['benefits_header']),
          data['benefits']
        ].reject(&:blank?).join
      end

      def build_location_string(data)
        [
          data.dig('location', 'name'),
          data.dig('location', 'city'),
          data.dig('location', 'province')
        ].reject(&:blank?).join(', ')
      end

      def fetch_salary(data)
        salary_low = number_with_delimiter(data['compensation_minimum'])
        salary_high = number_with_delimiter(data['compensation_maximum'])
        currency = data['compensation_currency']
        symbol = CURRENCY_CONVERTER[currency&.downcase]&.first
        salary_low == salary_high ? "#{symbol}#{salary_low} #{currency}" : "#{symbol}#{salary_low} - #{symbol}#{salary_high} #{currency}"
      end
    end
  end
end
