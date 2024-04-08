module Ats
  module Smartrecruiters
    module CompanyDetails
      def find_or_create_company(_ats_identifier)
        # TODO: add method here
        return
      end

      def get_company_details(url, ats_system, ats_identifier)
        p "Getting smartrecruiters company details - #{url}"

        # TODO: Update to scrape company details given lack of API endpoint for company information
        # TODO: Add total live based on total number of jobs returned by API call (for each ATS system)

        company_name = ats_identifier.capitalize
        company = Company.find_by(company_name:)

        if company
          p "Existing company - #{company.company_name}"
        else
          company = Company.create(
            company_name:,
            ats_identifier:,
            applicant_tracking_system_id: ats_system.id,
            url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}",
            url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}"
          )

          company.total_live = fetch_total_live(ats_system, ats_identifier)
          # p "Total live - #{company.total_live}"

          p "Created company - #{company.company_name}" if company.persisted?
        end
        p company
        company
      end

      def fetch_total_live(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}/postings"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['totalFound']
      end

      # TODO: Add fetch company description off first job posting if there
    end
  end
end
