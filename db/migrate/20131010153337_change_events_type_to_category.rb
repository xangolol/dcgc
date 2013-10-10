class ChangeEventsTypeToCategory < ActiveRecord::Migration
  def change
  	rename_column :events, :event_type, :category
  end
end
