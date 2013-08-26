require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Home') }
    it { should have_title('Home') }


  end
end
