class LoginFailed < StandardError
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from LoginFailed,with: :login_failed

  def login_failed
    render template: 'shared/login_failed',status: 401
  end
end
