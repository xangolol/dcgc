require 'spec_helper'

describe "ExpensePages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    log_in user
     FactoryGirl.create(:expense, user: user)
  end


  describe "index" do
    before { visit groceries_path }

    it { should have_title("Groceries") }
    it { should have_content("Groceries") }

    describe "Expenses overview table" do
      it { should have_content("Food") }
      it { should have_content("Common goods") }
      it { should have_selector(".table tr.user-1", count: 1) }
      it { should_not have_selector("tr.user-2") }

      it { should have_link('Next month', href: groceries_path + "?month=1") }
      it { should have_link('Previous month', href: groceries_path + "?month=-1") }
      it { should have_css("#month-navigation div.text-center", text: Time.now.strftime("%B")) }

      it { should have_content(user.expenses.first.date.to_s(:long_ordinal)) }

      describe "switch month" do
        before do 
          FactoryGirl.create(:expense, user: user, date: Time.now.to_date.next_month)
          click_link("Next month")
        end

        it { should have_selector(".table tr.user-1", count: 1) }
        it { should have_content(user.expenses.last.date.to_s(:long_ordinal)) }
        it { should have_css("#month-navigation div.text-center", text: Time.now.to_date.next_month.strftime("%B")) }
      end
    end
  end
end
