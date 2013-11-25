require 'spec_helper'
require 'pp'

describe Event do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event, user: user) }

  subject { event }

  it { should respond_to(:category) }
  it { should respond_to(:date) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) {should eq user }

  it { should be_valid }

  describe "no user_id" do
    before { event.user_id = nil }
    it {should_not be_valid }
  end

  describe "validate type" do

    describe "empty type" do
      before { event.category = nil }
      it {should_not be_valid }
    end

    describe "wrong types" do
      it "should be invalid" do
        types = %w(wrong dinners)
        types.each do |wrong_type|
          event.category = wrong_type
          expect(event).not_to be_valid
        end
      end
    end

    describe "correct types" do
      it "should be valid" do
        types = %w(dinner)
        types.each do |valid_type|
          event.category = valid_type
          expect(event).to be_valid
        end
      end
    end
  end

  describe "no date" do
    before { event.date = nil }
    it {should_not be_valid }
  end

  describe "the event should be unique" do
    before do
      @cloned_event = event.dup
      @cloned_event.save
    end
    
    it { @cloned_event.should_not be_valid }
  end

  describe "Methods" do
    before do 
      10.times { FactoryGirl.create(:event, user: user) }
      temp_user = FactoryGirl.create(:user) 
      FactoryGirl.reload 
      10.times { FactoryGirl.create(:event, user: temp_user) }
    end
    describe "should return the amount of dinner events" do
      it "only 1 event per day" do
        Event.dinner_count.should == 0
      end

      it "2 events per day" do
        Event.dinner_count.should == 20
      end
    end
  end
end
