class Event < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :date, presence: true
  validates :user_id, uniqueness: { scope: [:event_type, :date] }

  EVENT_TYPE_OPTIONS = ['dinner', 'dinner-extra']
  validates :event_type, inclusion: { in: EVENT_TYPE_OPTIONS}
  default_scope -> { order('date') }

  #TODO add dinner with external people
  #TODO finish dinner-extra modal
end
