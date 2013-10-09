class ChangeIndexInEvents < ActiveRecord::Migration
  def change
    remove_index :events, name: 'index_events_on_user_id_and_date_and_event_type'
    add_index :events, [:user_id, :date, :event_type, :dinner_guest], unique: true, name: 'index_events_date_type_guest'
  end
end
