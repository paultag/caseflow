class WebController < ApplicationController
  protect_from_forgery with: :exception
  layout 'application'

  sessionless_actions = %w/login login_submit logout/

  # Retrieve the Case object
  before_action 'get_kase', except: sessionless_actions

  # Check authentication
  before_action 'login_check', except: sessionless_actions

  # Check authorization
  before_action 'authorization_check', except: sessionless_actions

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

    certification_date = Time.now.to_s(:va_date)
    fields['17C_DATE'] = certification_date

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
    if is_authorized?(@kase, session[:username])
      return render 'unauthorized', layout: 'basic', status: 401
    end
  end

end
