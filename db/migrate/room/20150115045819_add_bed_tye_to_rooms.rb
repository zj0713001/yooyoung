class AddBedTyeToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :bed_type, :string
  end
end
