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

  def render_case(file, kase)
    render file: "web/#{file}", layout: 'application', locals: {kase: kase}
  end

end
