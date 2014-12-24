class AddHotelToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :hotel_id, :integer
  end
end
