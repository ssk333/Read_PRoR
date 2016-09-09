class LoginFailed < StandardError
end

class ApplicationController < ActionController::Base
  before_action :detect_mobile_variant
  protect_from_forgery with: :exception
  rescue_from LoginFailed,with: :login_failed

  def login_failed
    render template: 'shared/login_failed',status: 401
  end

  private
  def detect_mobile_variant
    request.variant = :mobile if request.user_agent =~ /iPhone/
  end
end
