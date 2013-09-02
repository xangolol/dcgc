require 'spec_helper'
require 'pp'

describe Event do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event, user: user) }

  subject { event }

  it { should respond_to(:event_type) }
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
      before { event.event_type = nil }
      it {should_not be_valid }
    end

    describe "wrong types" do
      it "should be invalid" do
        types = %w(wrong dinners)
        types.each do |wrong_type|
          event.event_type = wrong_type
          expect(event).not_to be_valid
        end
      end
    end

    describe "correct types" do
      it "should be valid" do
        types = %w(dinner)
        types.each do |valid_type|
          event.event_type = valid_type
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
end
