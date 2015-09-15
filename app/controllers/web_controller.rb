class WebController < ApplicationController
  protect_from_forgery with: :exception
  layout 'application'
  before_action 'login_check', except: %w/login login_submit logout/

  def index
    raise ActionController::RoutingError.new('Not Found')
  end

  def start
    @kase = get_case(params[:id])

    if @kase.ready_to_certify?
      return redirect_to action: :questions, params: params
    end

    render 'start'
  end

  def questions
    @kase = get_case(params[:id])

    if !@kase.ready_to_certify?
      return redirect_to action: :start, params: params
    end

    render 'questions'
  end

  def questions_submit
    kase = get_case(params[:id])

    # TODO Add a check for the two required params, sending the user back to `questions` with an error message if not there (maybe do this in a separate branch, since this wasn't there before and needs some design)

    fields = kase.initial_fields
    fields.merge!(params)

    certification_date = Time.now.to_s(:va_date)
    fields['17C_DATE'] = certification_date

    form_8 = FormVa8.new(fields)
    form_8.process!

    redirect_to action: :generate, params: {id: params[:id], file_name: form_8.file_name, certification_date: certification_date}
  end

  def generate
    @kase = get_case(params[:id])
    @file_name = params[:file_name]
    @certification_date = params[:certification_date]
    render 'generate'
  end

  def certify
    @kase = get_case(params[:id])
    corr = @kase.correspondent

    Case.transaction do
      @kase.bfdcertool = Time.now
      @kase.bf41stat = Date.strptime(params[:certification_date], Date::DATE_FORMATS[:va_date])
      @kase.save

      @kase.efolder_case.upload_form8(corr.snamef, corr.snamemi, corr.snamel, params[:file_name])
    end

    render 'certify'
  end

  def login
    @error_message = params[:error_message]
    render 'login', layout: 'basic'
  end

  def login_submit
    if is_valid_user?(params[:username], params[:password])
      session[:username] = params[:username]
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
  def login_check
    unless session[:username]
      session[:case_id] = params[:id] # temporary store for login
      redirect_to action: 'login'
    end
  end

end
