class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # -- Reusable methods to use across inheriting controllers --
  def get_case(bfkey)
    if ENV['CASEFLOW_TEST']
      MockCase.new(bfkey)
    else
      Case.find(bfkey)
    end
  end

end





