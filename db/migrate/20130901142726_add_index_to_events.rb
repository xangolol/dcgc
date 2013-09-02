class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, :event_type
    add_index :events, [:user_id, :date, :event_type], unique: true
  end
end
