class WebController < ApplicationController
  protect_from_forgery with: :exception

  def index
    render file: 'web/application'
  end

  def redirect
    redirect_to '/caseflow#/certifications/' + params[:id] + '/start'
  end
end
