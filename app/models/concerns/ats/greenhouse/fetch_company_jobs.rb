module Ats
  module Greenhouse
    module FetchCompanyJobs
      private

      def fetch_company_jobs(company)
        endpoint = "#{company.url_ats_api}/jobs"
        data = get_json_data(endpoint)
        return data['jobs']
      end
    end
  end
end
