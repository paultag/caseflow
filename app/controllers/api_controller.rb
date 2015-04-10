class ApiController < ApplicationController
  class InvalidApiToken < Exception; end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {error: 'Record Not Found', message: 'Check your parameters and try again'}, status: :not_found
  end

  protect_from_forgery with: :exception, unless: lambda { request.headers['X-API-TOKEN'] }
end