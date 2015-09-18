require 'java'
java_import java.sql.DriverManager
java_import java.sql.SQLException

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_case(bfkey)
    if ENV.has_key?('CASEFLOW_TEST') && !ENV['CASEFLOW_TEST'].empty?
      Caseflow::Fakes::Case.find(bfkey)
    else
      Case.find(bfkey)
    end
  end

  def is_valid_user?(username, password)
    db_url = Rails.application.config.database_configuration[Rails.env]['url']

    # Attempt to login to the database
    connection = nil
    begin
      connection = DriverManager.getConnection(db_url, username, password) # throws exception if login fails
    rescue
      return false
    ensure
      connection.close unless connection.nil?
    end

    true
  end
end
