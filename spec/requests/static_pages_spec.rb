require 'spec_helper'

describe "StaticPages" do
  let(:user){ FactoryGirl.create(:user) }
  subject { page }

  describe "Home page" do
    before do 
      visit root_path 
      log_in user
    end

    it { should have_content('Home') }
    it { should have_title('Home') }


  end
end
