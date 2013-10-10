class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :user_id
      t.date :date
      t.decimal :amount, precision: 8, scale: 2
      t.string :category
      t.string :note

      t.timestamps
    end
    add_index :expenses, :user_id
    add_index :expenses, :date
  end
end
