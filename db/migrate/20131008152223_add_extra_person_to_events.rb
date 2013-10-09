class AddExtraPersonToEvents < ActiveRecord::Migration
  def change
    add_column :events, :extra_person, :string
  end
end
