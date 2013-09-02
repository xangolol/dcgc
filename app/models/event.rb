class Event < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :date, presence: true
  validates :user_id, uniqueness: { scope: [:event_type, :date] }

  EVENT_TYPE_OPTIONS = ['dinner']
  validates :event_type, inclusion: { in: EVENT_TYPE_OPTIONS}
  default_scope -> { order('date') }
end
