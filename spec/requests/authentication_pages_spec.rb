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
      it { should have_link(user.name, '#') }
      it { should have_link('Log out', href: logout_path) }

      describe "logout" do
        before { click_link "Log out" }
        it { should have_title("Log in") }
        it { should_not have_link("Log out") }
      end
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }

    describe "not logged in" do
      before do
        visit root_path
        log_in user
      end
      
      it { should have_link("Log out", logout_path) }
    end

    describe "in the Events controller" do
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
    end
  end
end
