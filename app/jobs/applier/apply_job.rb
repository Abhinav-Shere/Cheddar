module Applier
  class ApplyJob < ApplicationJob
    queue_as :default
    sidekiq_options retry: false

    def perform(job_application_id, user_id)
      Applier::ApplyToJob.new(job_application_id, user_id).apply
    end
  end
end