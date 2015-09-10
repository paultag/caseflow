class WebController < ApplicationController
  protect_from_forgery with: :exception

  def index
    raise ActionController::RoutingError.new('Not Found')
  end

  def start
    kase = get_case(params[:id])

    if kase.ready_to_certify?
      return redirect_to action: :questions, params: params
    end

    render_case('start', kase)
  end

  def questions
    kase = get_case(params[:id])
    render_case('questions', kase)
  end

  def questions_submit
    kase = get_case(params[:id])

    # TODO Add a check for the two required params, sending the user back with an error message if not there

    fields = kase.initial_fields
    fields.merge!(params)

    certification_date = Time.now.to_s(:va_date)
    fields['17C_DATE'] = certification_date

    form_8 = FormVa8.new(fields)
    form_8.process!

    redirect_to action: :generate, params: {id: params[:id], file_name: form_8.file_name, certication_date: certification_date}
  end

  def render_case(file, kase)
    render file: "web/#{file}", layout: 'application', locals: {kase: kase}
  end

end
