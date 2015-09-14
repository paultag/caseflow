require 'java'
java_import java.sql.DriverManager
java_import java.sql.SQLException

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_case(bfkey)
    if ENV['CASEFLOW_TEST']
      Caseflow::Fakes::Case.find(bfkey)
    else
      Case.find(bfkey)
    end
  end

  def is_valid_user?(username, password)
    db_url = Rails.application.config.database_configuration[Rails.env]['url']

    # Attempt to login to the database
    begin
      connection = DriverManager.getConnection(db_url, username, password) # throws exception if login fails
      connection.close
    rescue
      return false
    end

    true
  end
end
