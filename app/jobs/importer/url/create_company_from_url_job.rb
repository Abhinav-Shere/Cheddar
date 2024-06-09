module Importer
  module Url
    class CreateCompanyFromUrlJob < ApplicationJob
      queue_as :default
      retry_on StandardError, attempts: 0

      def perform(url)
        Importer::URL::CreateCompanyFromUrl.new(url).create_company
      end
    end
  end
end