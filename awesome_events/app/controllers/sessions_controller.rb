class SessionsController < ApplicationController
  def create
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    sessions[:user_id] = uer.id
    redirect_to root_path,notice: 'ログインしました'
  end
end
