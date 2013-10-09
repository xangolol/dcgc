class ChangeExtraPersonToDinnerGuest < ActiveRecord::Migration
  def change
    rename_column :events, :extra_person, :dinner_guest
  end
end
