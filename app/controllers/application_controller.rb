class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :not_logged_in

  def selected_month
    DateTime.now + params[:month].to_i.months
  end

  private
    def not_logged_in
      unless logged_in?
        flash[:error] = "You must be logged in to access this section"
        redirect_to login_url
      end
    end
end
