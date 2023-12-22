module Ats::Greenhouse
  # TODO: Update greenhouse fields to be just the core set, with the additional set to be scraped each time

  extend ActiveSupport::Concern
  GREENHOUSE_FIELDS = {
    first_name: {
      interaction: :input,
      locators: 'first_name'
    },
    last_name: {
      interaction: :input,
      locators: 'last_name'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    city: {
      interaction: :input,
      locators: 'job_application[location]'
    },
    resume: {
      interaction: :upload,
      locators: 'button[aria-describedby="resume-allowable-file-types"'
    },
    # location_click: {
    #   interaction: :listbox,
    #   locators: 'ul#location_autocomplete-items-popup'
    # },
    # linkedin_profile: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-linkedin-profile"]'
    # },
    # personal_website: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]'
    # },
    # heard_from: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-how-did-you-hear-about-this-job"]'
    # },
    # require_visa?: {
    #   interaction: :input,
    #   locators: 'textarea[autocomplete="custom-question-would-you-need-sponsorship-to-work-in-the-uk-"]'
    # },
  }
end

#  Issue with standard form fields - 2x being cross-added
#  Reconcile standard set of form fields
#  Then add additional fields
#  Move service to be a background job after job.create
