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
end
