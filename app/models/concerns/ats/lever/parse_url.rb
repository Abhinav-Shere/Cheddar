module Ats
  module Lever
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        regex_formats = [
          %r{https://jobs\.lever\.co/(?<company_name>[^/]+)(?:/(?<job_id>[^/?]+))?},
          %r{https://jobs\.eu\.lever\.co/(?<company_name>[^/]+)(?:/(?<job_id>[^/?]+))?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
