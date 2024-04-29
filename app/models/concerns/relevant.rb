module Relevant
  extend ActiveSupport::Concern
  include Constants

  def relevant?(ats, job_data)
    title, job_location = ats.fetch_title_and_location(job_data)

    puts title, job_location
    p "title match: #{JOB_TITLE_KEYWORDS.any? { |keyword| title.downcase.match?(keyword) }}"
    p "location match: #{JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.downcase.match?(keyword) }}"

    title &&
      job_location &&
      JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.downcase.match?(keyword) } &&
      JOB_TITLE_KEYWORDS.any? { |keyword| title.downcase.match?(keyword) }
  end
end
