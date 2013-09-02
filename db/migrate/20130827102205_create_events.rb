class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :date
      t.string :event_type
      t.integer :user_id

      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :date
  end
end
