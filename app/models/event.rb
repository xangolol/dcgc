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
  def self.dinner_count
  	where("category = 'dinner' OR category = 'dinner-guest'").size
  end

  #TODO stop joining/moving on dates in the past
end
