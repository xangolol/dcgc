class Event < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :date, presence: true
  validates :user_id, uniqueness: { scope: [:event_type, :date, :dinner_guest] }

  EVENT_TYPE_OPTIONS = ['dinner', 'dinner-guest']
  validates :event_type, inclusion: { in: EVENT_TYPE_OPTIONS}
  default_scope -> { order('date') }

  #TODO Add tests lol...
  #TODO Remove guests
end
