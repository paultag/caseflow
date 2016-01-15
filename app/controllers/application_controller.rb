require 'java'

java_import java.sql.DriverManager
java_import java.sql.SQLException


class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_case(bfkey)
    if $CASEFLOW_TEST_MODE
      Caseflow::Fakes::Case.find(bfkey)
    else
      Case.find(bfkey)
    end
  end

  def is_ro_credentials_valid?(username, password)

    unless $CASEFLOW_TEST_MODE
      db_url = Rails.application.config.database_configuration[Rails.env]['url']

      begin
        # throws exception if login fails
        connection = DriverManager.getConnection(db_url, username, password)
      rescue SQLException
        return false
      end
      connection.close
    end
    return true
  end

  def is_unauthorized?(kase, username)
    ro = kase.bfregoff.try('upcase')
    return ro != username
  end
end
