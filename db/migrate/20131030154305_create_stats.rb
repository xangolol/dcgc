class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :name
      t.decimal :value, precision: 8, scale: 2

      t.timestamps
    end
    add_index :stats, :name
  end
end
