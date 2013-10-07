module SessionsHelper
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    current_user == user
  end

  def log_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session[:user_id] = nil
    self.current_user = nil
  end
end
