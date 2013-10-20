require 'spec_helper'

describe "ExpensePages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    log_in user
     FactoryGirl.create(:expense, user: user)
  end


  describe "index" do
    before { visit expenses_path }

    it { should have_title("Groceries") }
    it { should have_content("Groceries") }
    it { should have_button("Add new grocery") }

    describe "Expenses overview table" do
      it { should have_content("Food") }
      it { should have_content("Common goods") }
      it { should have_selector(".table tr.user-1", count: 1) }
      it { should_not have_selector("tr.user-2") }

      it { should have_link('Next month', href: expenses_path + "?month=1") }
      it { should have_link('Previous month', href: expenses_path + "?month=-1") }
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

    describe "adding groceries", js: true do
      before { click_button("Add new grocery") } 
      it { should have_selector("#modal .expense-form") }

      wrong_amounts = ["-2", "", "101"]
      wrong_amounts.each do |amount|
        describe "wrong amount" + amount do
          before do
            fill_in "Amount", with: amount
            click_button "Add grocery"
          end
          it { should have_selector("#modal .expense-form .control-group.error") }
        end
      end

      describe "success" do
        it "should add the grocery" do
          expect do
            fill_in "Amount", with: "15.50"
            click_button "Add grocery"
          end.to change(Expense, :count).by(+1)
        end
      end
    end
  end
end
