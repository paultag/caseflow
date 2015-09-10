module Caseflow
  def seld.is_child_path?(directory, path)
    path.cleanpath.to_s.start_with?(directory.cleanpath.to_s + '/')
  end
end

class FilesController < ApplicationController
  protect_from_forgery with: :exception

  def show
    @filepath = Rails.root + 'tmp' + params[:type] + [params[:id], params[:format]].join('.')
    if !Caseflow.is_child_path?(Rails.root + 'tmp', @filepath)
      head :not_found
    else
      send_file(@filepath, filename: [params[:id], 'pdf'].join('.'), type: 'application/pdf')
    end

  rescue
    head :not_found
  end
end
