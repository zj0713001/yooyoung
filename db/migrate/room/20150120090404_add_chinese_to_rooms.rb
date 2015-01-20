class AddChineseToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :chinese, :string
  end
end
