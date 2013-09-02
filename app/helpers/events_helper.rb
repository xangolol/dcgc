module EventsHelper

  def create_calendar
    current_month = DateTime.now + params[:month].to_i.months

    @days = days_of_month current_month.month, current_month.year
    shift_days
  end

  private

    def days_of_month(month, year = Time.now.year)
      days = Array.new
      number_of_days = Time.days_in_month month, year

      (1..number_of_days).each do |i|
        day = Hash.new
        day[:date] = Date.new(year, month, i)

        day[:monday] = day[:date].monday?
        day[:events] = add_day_events day[:date]
        days << day
      end
      days
    end

    #puts empty days infront of the first day, for the calendar layout
    def shift_days
      (@days.first[:date].cwday - 1).times do |i|
        @days.unshift({ empty: true })
      end

      @days.first[:monday] = true
    end

    def add_day_events(date)
      events = Hash.new
      events[:dinner] = Event.where("date = ? AND event_type = ?", date, 'dinner')
      events
    end
end
