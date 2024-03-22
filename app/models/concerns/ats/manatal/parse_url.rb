module Ats
  module Manatal
    module ParseUrl
      extend ActiveSupport::Concern

      def self.call(url)
        regex_formats = [
          %r{https://www\.careers-page\.com/(?<company_name>[^/]+)(?:/job/(?<job_id>[^/]+))?}
        ]

        regex_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id]
        end
        return nil
      end
    end
  end
end
