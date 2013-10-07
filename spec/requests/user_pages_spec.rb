require 'spec_helper'

describe "EventPages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    log_in user
  end


  describe "edit" do
    before { visit edit_user_path(user) }

    it { should have_title("Edit user") }
    it { should have_selector("h1", "Update your profile") }

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title("Edit user") }
      it { should have_selector('div.alert.alert-success') }
      it { should have_selector("h1", "Update your profile") }
      it { should have_field("user[name]", with: new_name) }
      it { should have_field("user[email]", with: new_email) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end