require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_content("Log in") }
    it { should have_title("Log in") }
  end

  describe "login" do
    before { visit login_path }

    describe "invalid informatio" do
      before { click_button "Log in" }

      it { should have_title("Log in") }
      it { should have_selector('div.alert.alert-error', text: 'Error') }
    end

    describe "valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { log_in user }

      it { should have_link('Calendar', href: calendar_path) }
      it { should have_link(user.name, href: edit_user_path(user)) }
      it { should have_link('Log out', href: logout_path) }

      describe "logout" do
        before { click_link "Log out" }
        it { should have_title("Log in") }
        it { should_not have_link("Log out") }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end
        
        describe "should have logged in" do
          it { should have_link("Log out", logout_path) }
        end
      end

      describe "in the Events controller" do
        describe "visiting the events index" do
          before { visit events_path }
          it { should have_title("Log in") }
        end

        describe "submitting to the create action" do
          before { post events_path }
          specify { expect(response).to redirect_to(login_path) }
        end

        describe "submitting to the destroy action" do
          before { delete event_path(1) }
          specify { expect(response).to redirect_to(login_path) }
        end
      end

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title("Log in") }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(login_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { log_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title('Edit user') }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(login_url) }
      end
    end
  end
end
