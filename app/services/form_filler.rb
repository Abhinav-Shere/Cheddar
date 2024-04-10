require 'open-uri'
require 'json'
require 'htmltoword'

class FormFiller
  include Capybara::DSL

  # TODO: Handle job posting becoming closed (redirect or notification on page)
  # TODO: Review code for inefficient loops and potential optimisations
  # TODO: Add ruby monitoring tools to monitor performance and execution
  # TODO: Implement caching for both user and form inputs. At the moment we request the database every time we want an input
  # TODO: Cache values at beginning of session and then update cache when user changes values
  # TODO: Enable multi-job application support in form_filler and cache before all applications are submitted
  # TODO: Restrict search to certain portions of the page

  # Could we implement caching for form inputs? So once you've done it once it becomes less intensive

  def fill_out_form(url, fields, job_application_id)
    session = Capybara::Session.new(:selenium)
    p "Created new session #{session}"

    @job_application = JobApplication.find_by_id(job_application_id)
    @user = @job_application.user
    @job = @job_application.job
    @errors = nil

    begin
      p "Visiting #{url}"
      session.visit(url)
      p "Successfully reached #{url}"
      find_apply_button(session).click
      fields.each do |field|
        field = field[1]
        handle_field_interaction(session, field)
      end
      take_screenshot_and_store(session, job_application_id)
      fields.each do |field|
        field[1]
        if field[0] == 'resume'
          file_path = Rails.root.join('tmp', "Cover Letter - #{@user.first_name} #{@user.last_name}.pdf")
          FileUtils.rm_f(file_path)
        elsif field[0] == 'cover_letter_'
          file_path = Rails.root.join('tmp',
          "Cover Letter - #{@job.job_title} - #{@job.company.company_name} - #{@user.first_name} #{@user.last_name}.docx")
          FileUtils.rm_f(file_path)
        end
      end
    rescue StandardError
      nil
    ensure
      session.driver.quit
    end

    # TODO: Add check on whether form has been submitted successfully
    # submit = find_submit_button.click rescue nil


    @job_application.update(status: 'Applied')
  end

  private

  def handle_field_interaction(session, field)
    case field['interaction']
    when 'input'
      begin
        session.fill_in(field['locators'], with: field['value'])
      rescue Capybara::ElementNotFound
        begin
          session.find(field['locators']).set(field['value'])
        rescue StandardError
          nil
        end
      end
    when 'combobox'
      begin
        select_option_from_combobox(session, field['locators'], field['option'], field['value'])
      rescue Capybara::ElementNotFound
        @errors = true
      end
    when 'radiogroup'
      begin
        select_option_from_radiogroup(session, field['locators'], field['option'], field['value'])
      rescue Capybara::ElementNotFound
        @errors = true
      end
    when 'listbox'
      begin
        select_option_from_listbox(session, field['locators'])
      rescue NoMethodError
        @errors = true
      end
    when 'select'
      begin
        select_option_from_select(session, field['locators'], field['option'], field['value'])
      rescue Capybara::ElementNotFound
        @errors = true
      end
    when 'checkbox'
      begin
        select_options_from_checkbox(session, field['locators'], field['value'])
      rescue Capybara::ElementNotFound
        @errors = true
      end
    when 'upload'
      begin
        upload_file(session, field['locators'], field['value']) unless field['value'] == ''
      rescue Capybara::ElementNotFound
        @errors = true
      end
    end
  end

  def find_apply_button(session)
    session.find(:xpath,
         "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
        end

  def find_submit_button(session)
    session.find(:xpath,
         "//button[contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'submit')] | //input[contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'submit')]")
  end

  def select_option_from_combobox(session, combobox_locator, option_locator, option_text)
    session.find(combobox_locator).click
    session.all(option_locator, text: option_text, visible: true)[0].click
  end

  def select_option_from_radiogroup(session, radiogroup_locator, option_locator, option_text)
    session.within(radiogroup_locator) do
      session.find(option_locator, text: option_text).click
    end
  end

  def select_option_from_listbox(session, listbox_locator)
    session.all("#{listbox_locator} li")[0].click
  end

  def select_option_from_select(session, listbox_locator, option_locator, option_text)
    session.within "##{listbox_locator}" do
      session.find(option_locator, text: option_text).click
    end
  rescue Selenium::WebDriver::Error::ElementNotInteractableError
    new_locator = session.find("label ##{listbox_locator}")
    new_locator.ancestor("label").find("a").click
    session.find("li", text: option_text).click
  end

  def select_options_from_checkbox(session, checkbox_locator, option_text)
    option_text = JSON.parse(option_text)
    begin
      session.within('label', text: checkbox_locator) do
        option_text.each do |option|
          session.check(option)
        rescue Capybara::ElementNotFound
        end
      end
    rescue Capybara::ElementNotFound
      session.within(:xpath, "//div[contains(text(), '#{checkbox_locator}')]") do
        option_text.each do |option|
          session.check(option)
        rescue Capybara::ElementNotFound
        end
      end
      @errors = true
    end
  end

  # rubocop:disable Security/Open
  def upload_file(session, upload_locator, file)
    if file.instance_of?(String)
      docx = Htmltoword::Document.create(file)
      file_path = Rails.root.join('tmp',
                                  "Cover Letter - #{@job.job_title} - #{@job.company.company_name} - #{@user.first_name} #{@user.last_name}.docx")
      File.binwrite(file_path, docx)
    else
      file_path = Rails.root.join('tmp', "Resume - #{@user.first_name} #{@user.last_name}.pdf")
      File.binwrite(file_path, URI.open(file.url).read)
    end
    begin
      session.find(upload_locator).attach_file(file_path)
    rescue Capybara::ElementNotFound
      session.attach_file(file_path) do
        session.find(upload_locator).click
      end
    end
  end
  # rubocop:enable Security/Open

  def take_screenshot_and_store(session, job_application_id)
    screenshot_path = Rails.root.join('tmp', "screenshot-#{job_application_id}.png")
    session.save_screenshot(screenshot_path)

    file = File.open(screenshot_path)
    job_app = JobApplication.find(job_application_id)
    job_app.screenshot.attach(io: file, filename: "screenshot-#{job_application_id}.png", content_type: 'image/png')

    File.delete(screenshot_path)
  end
end
