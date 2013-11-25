class Event < ActiveRecord::Base
	#callbacks

	#associations
  belongs_to :user
	has_paper_trail

  #validations
  validates :user_id, :date, presence: true
  validates :user_id, uniqueness: { scope: [:category, :date, :dinner_guest] }

  EVENT_CATEGORIES = ['dinner', 'dinner-guest']
  validates :category, inclusion: { in: EVENT_CATEGORIES}
  default_scope -> { order('date, user_id') }

  #methods
  #returns how many events have the dinner or dinner-guest category
  def self.dinner_count(no_singles = true)
    if no_singles
      where(date: self.multiple_dates).where("category = 'dinner' OR category = 'dinner-guest'").count
    else
      where("category = 'dinner' OR category = 'dinner-guest'").size
    end
  end

  #gives all the dates which have more than 1 event
  #TODO fix the smaller subsets
  def self.multiple_dates
    self.find_by_sql("SELECT date FROM events GROUP BY date HAVING COUNT(date([date]))> 1").map { |object| object.date }
  end

  #TODO stop joining/moving on dates in the past
end
