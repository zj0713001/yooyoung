class AddSequenceToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :sequence, :integer, default: 0
  end
end
