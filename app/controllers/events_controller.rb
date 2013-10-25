class EventsController < ApplicationController
  include EventsHelper
  before_action :correct_user, only: :destroy

  def index
    create_calendar
  end

  def show
  end

  def new
    @event = current_user.events.build(event_params)
    respond_to do |format|
      format.js
    end
  end

  def create
    event = current_user.events.build(event_params)
    if event.save
      if(event_params[:category] == "dinner-guest")
        person = event_params[:dinner_guest].capitalize
      else
        person = "You"
      end

      flash[:success] = person + " joined dinner on " + event_params[:date]
    else
      flash[:error] = "You have already joined dinner on this date"
    end
    redirect_to calendar_url
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "You have unjoined dinner on " + event_params[:date]
    redirect_to calendar_url
  end

  private
    def event_params
      params.require(:event).permit(:category, :date, :dinner_guest)
    end

    def correct_user
      @event = current_user.events.find_by id: params[:id]
      redirect_to root_url if @event.nil?
    end
end
