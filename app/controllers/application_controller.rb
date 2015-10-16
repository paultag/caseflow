require 'java'

java_import java.sql.DriverManager


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

  def is_unauthorized?(kase, username)
    ro = kase.bfregoff.try('upcase')
    return ro != username
  end
end
