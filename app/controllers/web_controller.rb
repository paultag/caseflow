class WebController < ApplicationController
  protect_from_forgery with: :exception
  layout 'application'

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

    # TODO Return the user to `start` if kase is not ready for certifcation

    render 'questions'
  end

  def questions_submit
    kase = get_case(params[:id])

    # TODO Add a check for the two required params, sending the user back to `questions` with an error message if not there (maybe do this in a separate branch, since this wasn't there before)

    fields = kase.initial_fields
    fields.merge!(params)

    certification_date = Time.now.to_s(:va_date)
    fields['17C_DATE'] = certification_date

    form_8 = FormVa8.new(fields)
    form_8.process!

    redirect_to action: :generate, params: {id: params[:id], file_name: form_8.file_name, certication_date: certification_date}
  end

  def generate
    @kase = get_case(params[:id])
    @file_name = params[:file_name]
    @certification_date = params[:certification_date]
    render 'generate'
  end

  def certify
    puts 'certify_stub'
    render nothing: true
  end
end
