class SessionsController < ApplicationController
  skip_before_action :not_logged_in, only:[:create, :new]

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to root_url
    else
      flash.now[:error] = "Error: Wrong email/password combination"
      render 'new'
    end
  end

  def new
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
