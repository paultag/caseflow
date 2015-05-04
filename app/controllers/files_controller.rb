class FilesController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @filepath = Rails.root + 'tmp' + params[:type] + [params[:id], params[:format]].join('.')

    send_file(@filepath, filename: [params[:id], 'pdf'].join('.'), type: 'application/pdf')
  rescue
    head :not_found
  end
end