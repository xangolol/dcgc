require 'spec_helper'

describe Expense do
  let(:user) { FactoryGirl.create(:user) }
  let(:expense) { FactoryGirl.create(:expense, user: user) }
  let(:expense_common) { FactoryGirl.create(:expense, user: user, category: 'common-goods') }

  subject { expense }

  it { should respond_to(:category) }
  it { should respond_to(:date) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:amount) }
  it { should respond_to(:note) }

  its(:user) {should eq user }

  it { should be_valid }

  describe "missing required information" do
  	describe "no user_id" do
  		before { expense.user_id = nil }
    	it { should_not be_valid }
  	end

  	describe "no date" do
  		before { expense.date = nil }
    	it { should_not be_valid }
  	end

  	describe "no category" do
  		before { expense.category = nil }
    	it { should_not be_valid }
  	end

  	describe "no amount" do
  		before { expense.amount = nil }
    	it { should_not be_valid }
  	end
  end

  describe "amount should be rounded to 2 decimals" do
    before do 
      expense.amount = 15.5428 
      expense.save
    end
    it "blabla" do
      expect(expense.reload.amount.to_s).to eq("15.54")
    end
  end

  describe "categories" do
  	describe "wrong categories" do
  		it "should be invalid" do
        types = %w(wrong f00d fod others)
        types.each do |wrong_category|
          expense.category = wrong_category
          expect(expense).not_to be_valid
        end
      end
  	end

  	describe "correct categories" do
  		it "should be valid" do
        types = %w(food common-goods other)
        types.each do |correct_category|
          expense.category = correct_category
          expect(expense).to be_valid
        end
      end
  	end
  end

  describe "with note content that is to long" do
  	before { expense.note = "a" * 301 }
  	it { should_not be_valid }
  end

  describe "Stats" do
    before do 
      expense 
      expense_common
    end

    describe "Total dinner cost should change on" do
      it "Creation" do
        expect { FactoryGirl.create(:expense, user: user) }.to change { Stat.get_total_dinner_cost }.by(+10.5)
      end

      it "Update higher" do
        expect do
          expense.amount = 12.5
          expense.save
        end.to change { Stat.get_total_dinner_cost }.by(+2)
      end

      it "Update lower" do
        expect do
          expense.amount = 8.5
          expense.save
        end.to change { Stat.get_total_dinner_cost }.by(-2)
      end

      it "Descruction" do
        expect { expense.destroy}.to change { Stat.get_total_dinner_cost }.by(-10.5)
      end
    end

    describe "Total dinner cost should not change for non food categories" do
      it "Creation" do
        expect { FactoryGirl.create(:expense, user: user, category: 'common-goods') }.to_not change { Stat.get_total_dinner_cost }
      end

      it "Update" do
        expect do
          expense_common.amount = 8.5
          expense_common.save
        end.to_not change { Stat.get_total_dinner_cost }
      end

      it "Destruction" do
        expect { expense_common.destroy }.to_not change { Stat.get_total_dinner_cost }
      end
    end

    describe "Switching between categories" do
      it "food to non food" do
        expect do
          expense.category = 'common-goods'
          expense.amount = 6.5
          expense.save
        end.to change { Stat.get_total_dinner_cost }.by(-6.5)
      end

      it "non food to food" do
        expect do
          expense_common.category = 'food'
          expense_common.amount = 6.5
          expense_common.save
        end.to change { Stat.get_total_dinner_cost }.by(+6.5)
      end
    end
  end
end
