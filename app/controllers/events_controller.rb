class EventsController < ApplicationController
  include EventsHelper

  def index
    create_calendar
  end

  def show
  end

  def create
    event = current_user.events.build(event_params)
    if event.save
      flash[:success] = "You have joined dinner on " + event_params[:date]
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
      params.require(:event).permit(:event_type, :date)
    end
end
