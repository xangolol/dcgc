include ApplicationHelper

def log_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    post sessions_path, :email => user.email, :password => user.password
  else
    visit login_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end