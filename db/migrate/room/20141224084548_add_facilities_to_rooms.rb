class AddFacilitiesToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :facilities, :text
  end
end
