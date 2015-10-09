module Caseflow
  def self.safe_join(directory, path)
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
  protect_from_forgery with: :exception
  layout 'application'

  sessionless_actions = %w/login login_submit logout/
  non_case_actions = sessionless_actions + %w/show_form/

  # Check authentication
  before_action 'login_check', except: sessionless_actions

  # Retrieve the Case object
  before_action 'get_kase', except: non_case_actions
  # Check authorization
  before_action 'authorization_check', except: non_case_actions
  # Check that the case is ready for certification.
  before_action 'case_ready_check', except: non_case_actions

  def index
    raise ActionController::RoutingError.new('Not Found')
  end

  def start
    if @kase.ready_to_certify?
      return redirect_to action: :questions, id: params[:id]
    end

    render 'start'
  end

  def questions
    if !@kase.ready_to_certify?
      return redirect_to action: :start, id: params[:id]
    end

    render 'questions'
  end

  def questions_submit

    # TODO Add a check for the two required params, sending the user back to `questions` with an error message if not there (maybe do this in a separate branch, since this wasn't there before and needs some design)

    fields = @kase.initial_fields
    fields.merge!(params)

    # Prepare fields for PDF generation
    certification_date = Time.now.to_s(:va_date)
    fields['17C_DATE'] = certification_date

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

    # Switch all question 13 checkboxes to true if checked from 'on' value (but don't accidentally get the Other text input box)
    fields.each do |key, val|
      if key =~ /^13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_/ && key !~ /OTHER_REMARKS$/ && val
        fields[key] = true
      end
    end

    unless fields['13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER']
      fields.delete('13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER_REMARKS')
    end

    # This check will never be reached if front-end validation works (not ideal, because it loses all the values in the form)
    if blank?(fields['17A_SIGNATURE_OF_CERTIFYING_OFFICIAL']) || blank?(fields['17B_TITLE'])
      # @error_message = 'Please provide an answer questions for 17A and 17B'
      return redirect_to action: :questions, params: fields
    end

    # Generate Form 8 PDF
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

    Case.transaction do
      @kase.bfdcertool = Time.now
      @kase.bf41stat = Date.strptime(params[:certification_date], Date::DATE_FORMATS[:va_date])
      @kase.save

      @kase.efolder_case.upload_form8(corr.snamef, corr.snamemi, corr.snamel, params[:file_name])
    end

    render 'certify'
  end

  def error
    @kase.bf41stat = nil
    @kase.bfdmcon = nil
    @kase.bfms = nil
    @kase.save

    render 'error'
  end

  def show_form
    @filepath = Caseflow.safe_join(Rails.root + 'tmp' + 'forms', "#{params[:id]}.pdf")
    if @filepath.nil?
      head :not_found
    else
      send_file(@filepath, type: 'application/pdf')
    end

  rescue
    head :not_found
  end

  def login
    @error_message = params[:error_message]
    render 'login', layout: 'basic'
  end

  def login_submit
    if is_valid_user?(params[:username], params[:password])
      session[:username] = params[:username].upcase
      redirect_to action: 'start', id: session.delete(:case_id) # remove the case id now that login is done
    else
      redirect_to action: 'login', params: {error_message: 'Username and password did not work.'}
    end
  end

  def logout
    reset_session
    redirect_to action: 'login'
  end

  # -- Action filter --

  # Gets the Case object once, preventing multiple queries between before_action's and normal actions
  def get_kase
    @kase = get_case(params[:id])
  end

  def login_check
    unless session[:username]
      session[:case_id] = params[:id] # temporary store for login
      redirect_to action: 'login'
    end
  end

  def authorization_check
    if is_unauthorized?(@kase, session[:username])
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

  # -- Helper Method --
  def blank?(str)
    # There is a blank? method in ActiveSupport, but avoiding since it'll do more things than just add this to String
    str =~ /^\s*$/
  end

end
