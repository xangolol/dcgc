require 'spec_helper'

describe "EventPages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    log_in user
    FactoryGirl.create(:event, user: user, date: Time.now)
    FactoryGirl.create(:event, user: user, date: Time.now, category: "dinner-guest", dinner_guest: "test")
  end


  describe "index" do
    before { visit events_path }

    it { should have_title("Calendar") }
    it { should have_selector("h1", "Calendar") }

    describe "Calendar" do

      it { should have_selector("#month-navigation .text-center", DateTime.now.strftime("%B")) }
      it { should have_link('Next month', href: calendar_path + "?month=1") }
      it { should have_link('Previous month', href: calendar_path + "?month=-1") }

      it { should have_selector('.day', count: Time.days_in_month(Time.now.month) + (Date.new(Time.now.year, Time.now.month, 1).cwday - 1) + 7) }
      it { should have_selector('.day .events-container .dinner-events .dinner-event')}
        it { should have_selector(".dinner-guest-event") }
      
      describe "joining dinner" do
        it "should be able to join dinner" do
          expect do
            click_button('Join', match: :first)
          end.to change(Event, :count).by(+1)
        end
      end

      describe "unjoining dinner" do
        it "should be able to unjoin dinner" do
          expect do
            click_button('Unjoin', match: :first)
          end.to change(Event, :count).by(-1)
        end
      end

      describe "adding dinner guest", js: true do
        before { page.find(".dinner-guest", match: :first).click }
        it { should have_selector("#modal .new_event") }

        describe "submit the form" do

          it "should add an event" do
            expect do
              fill_in "event_dinner_guest", with: "Tester"
              click_button "Add dinner guest"
            end.to change(Event, :count).by(+1)
          end
        end
      end

      describe "removing dinner guest" do
        it { should have_selector(".dinner-guest-event .icon-remove") }

        it "click the link" do
          expect do
           find(".dinner-guest-event .dinner-label a").click
          end.to change(Event, :count).by(-1)
        end
      end
    end
  end
end
