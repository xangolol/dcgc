require 'spec_helper'

describe Expense do
  let(:user) { FactoryGirl.create(:user) }
  let(:expense) { FactoryGirl.create(:expense, user: user) }

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
end
