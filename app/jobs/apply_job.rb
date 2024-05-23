class ApplyJob < ApplicationJob
  include Defaults::DefaultMale
  include Defaults::DefaultFemale

  queue_as :default
  sidekiq_options retry: false

  def perform(job_application_id, user_id)
    p "Hello from the job application job!"
    application = JobApplication.find(job_application_id)
    job = application.job
    user = User.find(user_id)

    application_criteria = assign_values_to_form(application, user)
    fields_to_fill = application_criteria

    form_filler = FormFiller.new
    result = form_filler.fill_out_form(job.posting_url, fields_to_fill, job_application_id)
    user_channel_name = "job_applications_#{user.id}"

    status = result[:success] ? "Applied" : "Submission Failed"

    ActionCable.server.broadcast(
      user_channel_name,
      {
        event: "job_application_submitted",
        job_application_id: application.id,
        user_id: application.user.id,
        job_id: job.id,
        status:
      }
    )
  end

  private

  def assign_values_to_form(application, user)
    application_criteria = application.job.application_criteria
    custom_fields = {}
    ApplicationResponse.where(job_application_id: application.id).each do |response|
      custom_fields[response.field_name] = response.field_value
    end

    application_criteria.each_key do |key|
      if user.respond_to?(key) && user.send(key).present?
        application_criteria[key]['value'] = user.send(key)
      else
        application_criteria[key]['value'] = custom_fields[key]
        # p "Warning: defaults does not have a method or attribute '#{key}'. Using NIL value instead"
        # application_criteria[key]['value'] = nil
      end
    end
    return application_criteria
  end
end
