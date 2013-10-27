class Event < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :date, presence: true
  validates :user_id, uniqueness: { scope: [:category, :date, :dinner_guest] }

  EVENT_CATEGORIES = ['dinner', 'dinner-guest']
  validates :category, inclusion: { in: EVENT_CATEGORIES}
  default_scope -> { order('date, user_id') }

  has_paper_trail

  #TODO stop joining/moving on dates in the past
end
