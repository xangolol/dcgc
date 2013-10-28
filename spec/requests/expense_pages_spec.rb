require 'spec_helper'

describe "ExpensePages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let!(:expense) { FactoryGirl.create(:expense, user: user) }

  before do
    log_in user
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
      it { should have_link('Edit') }

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

    describe "editing groceries", js: true do
      before { click_link("Edit") }
      it { should have_selector("#modal .expense-form #edit_expense_1") }
      it { should have_field("Amount", with: "10.5") }

      describe "success" do
        before do
          fill_in "Amount", with: "14.44"
          tomorrow = Time.now.to_date.next_day
          select tomorrow.day.to_s, from: "expense_date_3i"
          select I18n.t("date.month_names")[tomorrow.month], from: "expense_date_2i"
          select  tomorrow.year.to_s, from: "expense_date_1i"
          select "Common-goods", from: "Category"
          click_button "Edit grocery"
        end

        it { should have_content "14.44" }
        it { should have_content Time.now.to_date.next_day.to_s(:long_ordinal) }
        it { should have_selector ".common-good-expenses tr.user-#{user.id}"}
      end

      describe "deleting groceries" do
        it {should have_button "Remove grocery" }

        it "should delete the grocery" do
          expect { click_button "Remove grocery" }.to change(Expense, :count).by(-1)
        end
      end
    end
  end
end
