class WebController < ApplicationController
  protect_from_forgery with: :exception

  def index
    render file: 'web/application'
  end
end