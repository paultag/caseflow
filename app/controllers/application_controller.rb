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

  def is_ro_credentials_valid?(username, password)
    
    db_url = Rails.application.config.database_configuration[Rails.env]['url']

    begin
      # throws exception if login fails
      connection = DriverManager.getConnection(db_url, username, password)
    rescue SQLException
      return false
    end
    connection.close
    return true
  end

  def is_unauthorized?(kase, username)
    ro = kase.bfregoff.try('upcase')
    return ro != username
  end
end
