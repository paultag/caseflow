require 'uri'

module Caseflow
  def self.safe_join(directory, path)
    if /\x00/ =~ path
      return nil
    end
    child = directory + path
    if Caseflow.is_child_path?(directory, child)
      return child
    else
      return nil
    end
  end

  def self.is_child_path?(directory, path)
    path.cleanpath.to_s.start_with?(directory.cleanpath.to_s + '/')
  end
end


class WebController < ApplicationController
  protect_from_forgery with: :exception, except: %w/ssoi_saml_callback/
  layout 'application'

  # Constants
  REMARKS_PAGE_1_MAX_LENGTH = 695
  CONTINUED = ' (continued)'
  REMARKS_CONTINUED = "\n\nRemarks Continued:"
  SEE_PAGE_2 = ' (see continued remarks page 2)'
  XA_ROLLOVER_CAP = 159

  sessionless_actions = %w/login login_ro_submit ssoi_saml_callback logout/
  non_case_actions = sessionless_actions + %w/show_form http_404_not_found/

  # Check authentication
  before_action 'login_check', except: sessionless_actions

  # Retrieve the Case object
  before_action 'load_case', except: non_case_actions
  # Check authorization
  before_action 'authorization_check', except: non_case_actions
  # Check that the case is ready for certification.
  before_action 'case_ready_check', except: non_case_actions

  def index
    raise ActionController::RoutingError.new('Not Found')
  end

  def handle_vbms_errors(&block)
    begin
      return block.call
    rescue VBMS::ClientError => e
      return render 'vbms_failure', layout: 'basic', status: 502
    end
  end

  def http_404_not_found
    render '404', layout: 'basic', status: 404
  end

  def start
    handle_vbms_errors do
      if @kase.ready_to_certify?
        return redirect_to action: :questions, id: params[:id]
      end
      render 'start'
    end
  end

  def questions
    handle_vbms_errors do
      if !@kase.ready_to_certify?
        return redirect_to action: :start, id: params[:id]
      end
    end

    render 'questions'
  end

  def questions_submit

    # TODO Add a check for the two required params, sending the user back to `questions` with an error message if not there (maybe do this in a separate branch, since this wasn't there before and needs some design)
    fields = params

    # Prepare fields for PDF generation

    ## Override user entered fields (since they are disabled on the frontend)
    initial_fields = @kase.initial_fields
    fields['2_FILE_NO'] = initial_fields['2_FILE_NO']
    fields['15_NAME_AND_LOCATION_OF_CERTIFYING_OFFICE'] = initial_fields['15_NAME_AND_LOCATION_OF_CERTIFYING_OFFICE']
    fields['16_ORGANIZATIONAL_ELEMENT_CERTIFIYING_APPEAL'] = initial_fields['16_ORGANIZATIONAL_ELEMENT_CERTIFIYING_APPEAL']

    certification_date = Time.now.to_s(:va_date)
    fields['17C_DATE'] = certification_date

    ## Clear not applicable fields
    fields = fields.each{|key, value| fields.delete(key) if value == 'NOT_APPLICABLE' }


    ## Ensure that values are not set when a dependent question makes the answer not applicable
    if fields['8B_POWER_OF_ATTORNEY'] == '8B_POWER_OF_ATTORNEY'
      fields['8B_POWER_OF_ATTORNEY'] = true
      fields.delete('8B_REMARKS')
    elsif fields['8B_POWER_OF_ATTORNEY'] == '8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE'
      fields['8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE'] = true
    end

    if fields['9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646'] == 'yes'
      fields.delete('9B_IF_VA_FORM_646_IS_NOT_OF_RECORD_EXPLAIN')
    end

    if fields['10B_IF_HELD_IS_TRANSCRIPT_IN_FILE'] == 'yes'
      fields.delete('10C_IF_REQUESTED_BUT_NOT_HELD_EXPLAIN')
    end

    if fields['11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE'] == 'no'
      fields.delete('11B_HAVE_THE_REQUIREMENTS_OF_38_USC_BEEN_FOLLOWED')
    end

    ## Switch all question 13 checkboxes to true if checked from 'on' value (but don't accidentally get the Other text input box)
    fields.each do |key, val|
      if key =~ /^13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_/ && key !~ /OTHER_REMARKS$/ && val
        fields[key] = true
      end
    end

    if !fields['13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER_REMARKS'].blank?
      fields['13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER'] = true
    end



    # This check will never be reached if front-end validation works (not ideal,
    # because it loses all the values in the form)
    if fields['17A_SIGNATURE_OF_CERTIFYING_OFFICIAL'].blank? || fields['17B_TITLE'].blank?
      # @error_message = 'Please provide an answer questions for 17A and 17B'
      return redirect_to action: :questions, params: fields
    end

    # Generate Form 8 PDF
    fields = WebController.field_rollover(fields)
    form_8 = FormVa8.new(fields)
    form_8.process!

    redirect_to action: :generate, params: {id: params[:id], file_name: form_8.file_name, certification_date: certification_date}
  end

  def generate
    @file_name = params[:file_name]
    @certification_date = params[:certification_date]
    render 'generate'
  end

  def certify
    corr = @kase.correspondent

    handle_vbms_errors do
      Case.transaction do
        @kase.bfdcertool = Time.now
        @kase.bf41stat = Date.strptime(params[:certification_date], Date::DATE_FORMATS[:va_date])
        @kase.save

        @kase.efolder_case.upload_form8(corr.snamef, corr.snamemi, corr.snamel, params[:file_name])
      end
    end

    render 'certify'
  end

  def error
    @kase.bf41stat = nil
    @kase.bfdmcon = nil
    @kase.bfms = nil
    @kase.save

    render 'error', layout: 'basic'
  end

  def show_form
    @filepath = Caseflow.safe_join(Rails.root + 'tmp' + 'forms', "#{params[:id]}.pdf")
    if @filepath.nil?
      head :not_found
    else
      send_file(@filepath, type: 'application/pdf', disposition: 'inline')
    end

  rescue
    head :not_found
  end

  def login
    if !session[:username] && ssoi_configured
      redirect_to Rails.application.config.login_url
    else
      @error_message = params[:error_message]
      render 'login', layout: 'basic'
    end
  end

  def redirect_to_case
    case_id = session.delete(:case_id)
    if case_id.nil?
      # Send them to a generic 404 page if they didn't get here via VACOLS
      redirect_to '/caseflow/'
    else
      redirect_to action: 'start', id: case_id
    end
  end

  def login_ro_submit
    if is_ro_credentials_valid?(params[:username], params[:password])
      session[:ro] = params[:username].upcase
      redirect_to_case
    else
      redirect_to action: 'login', params: {error_message: 'Username and password did not work.'}
    end
  end

  def ssoi_saml_callback
    # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
    #  (for more information on data that's commonly set on OmniHash plugins;
    #   we should look for any SAML-local data we want to squirl away in the
    #   session for this)
    auth = request.env["omniauth.auth"]

    session[:username] = auth['uid']
    session[:full_auth_data] = auth

    # XXX: In the case of falure, OmniAuth seems to redirect to a /failure/
    #      endpoint. Let's validate that assumption and ensure we don't need
    #      a second codepath to deal with failed logins here.
    redirect_to_case
  end

  def logout
    reset_session
    redirect_to action: 'login'
  end

  # -- Action filter --

  # Gets the Case object once, preventing multiple queries between
  # before_action's and normal actions
  def load_case
    begin
      @kase = get_case(params[:id])
    rescue ActiveRecord::RecordNotFound
      return render 'not_found', layout: 'basic', status: 404
    end
  end

  def login_check
    if !session[:username] && ssoi_configured
      # temporary store for login
      session[:case_id] = params[:id]
      redirect_to action: 'login'
    elsif !session[:ro]
      session[:case_id] = params[:id]
      redirect_to action: 'login'
    end
  end

  def ssoi_configured
    ENV.has_key?('SSOI_SAML_XML_LOCATION') && ENV.has_key?('SSOI_SAML_PRIVATE_KEY_LOCATION')
  end

  def authorization_check
    if is_unauthorized?(@kase, session[:ro])
      return render 'unauthorized', layout: 'basic', status: 401
    end
  end

  def case_ready_check
    if !@kase.bfdnod || !@kase.bfd19 || !@kase.bfdsoc
      @reason = :not_ready
      return render 'not_ready', layout: 'basic', status: 403
    elsif @kase.folder.file_type == 'Paper' || @kase.folder.file_type == 'VVA'
      @reason = :paper
      return render 'not_ready', layout: 'basic', status: 403
    end
  end

  # --- Helper Methods ---
  def self.field_rollover(field_hash)

    fields = field_hash.dup
    remarks_full = fields['14_REMARKS_INITIAL']
    remarks_page_1 = ''
    remarks_page_2 = ''

    # Box 5A is capped at 200 characters (arbitrary choice), rollover to page 2 if over cap
    fields['5A_SERVICE_CONNECTION_FOR'], field_5a_rollover = WebController.field_xa_rollover(fields['5A_SERVICE_CONNECTION_FOR'], '5A')
    remarks_page_2 << field_5a_rollover

    # Box 6A is capped at 200 characters (arbitrary choice), rollover to page 2 if over cap
    fields['6A_INCREASED_RATING_FOR'], field_6a_rollover = WebController.field_xa_rollover(fields['6A_INCREASED_RATING_FOR'], '6A')
    remarks_page_2 << field_6a_rollover

    # Box 7A is capped at 200 characters (arbitrary choice), rollover to page 2 if over cap
    fields['7A_OTHER'], field_7a_rollover = WebController.field_xa_rollover(fields['7A_OTHER'], '7A')
    remarks_page_2 << field_7a_rollover

    # Remarks field, itself
    remarks_full = fields['14_REMARKS_INITIAL']
    remarks = WebController.remarks_field_rollover(remarks_full)
    remarks_page_1 << remarks[0]
    remarks_page_2 << remarks[1]

    fields['14_REMARKS_INITIAL'] = remarks_page_1
    fields['14_REMARKS_CONTINUED'] = remarks_page_2
    fields
  end

  def self.field_xa_rollover(value, field_label)
    if value.length > 200
      field = "#{value[0..(XA_ROLLOVER_CAP-1)]}#{SEE_PAGE_2}"
      rollover = "\n\n#{field_label} Continued:\n#{value[XA_ROLLOVER_CAP..(value.length)]}"
    else
      field = value
      rollover = ''
    end

    [field, rollover]
  end

  def self.remarks_field_rollover(remarks)
    # Remarks box on page 1 can handle 713 characters straight or several
    # newlines with 1 line sentences. Newlines and the associated spacing make
    # it hard to do figure out the amount of space remaining without much
    # complexity. To simplify, will rollover to page 2 after first newline and
    # any characters past 695 characters before the first newline 695 and not
    # 713, allows for ' (continued)' to be appended for multiple lines ... no,
    # the math doesn't make sense, but avoids word wrap algorithm in the PDF
    # generator

    remarks_lines = remarks.split("\n")

    remarks_lines.each { |line| line.strip! }
    first_line = remarks_lines[0] || ''
    if first_line.length > REMARKS_PAGE_1_MAX_LENGTH
      remarks_1 = first_line[0..(REMARKS_PAGE_1_MAX_LENGTH-1)]
      remarks_2 = "\n#{first_line[(REMARKS_PAGE_1_MAX_LENGTH)..(first_line.length)]}"
    else
      remarks_1 = first_line
      remarks_2 = ''
    end

    if remarks_lines.length > 1
      remarks_lines[1, remarks_lines.length].each do |line|
        remarks_2 << "\n#{line}"
      end
    end

    if !remarks_2.empty?
      remarks_1 << CONTINUED
      remarks_2 = "#{REMARKS_CONTINUED}#{remarks_2}"
    end

    [remarks_1, remarks_2]
  end
end
