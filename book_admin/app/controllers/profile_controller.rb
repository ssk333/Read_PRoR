class ProfileController < ApplicationController
  def show
  end

  def edit
  end

  def update
    user = current_user
    # params[:user] => {name: "bob",email: "bob@example.com"}
    user.update(params[:user])
  end
end
