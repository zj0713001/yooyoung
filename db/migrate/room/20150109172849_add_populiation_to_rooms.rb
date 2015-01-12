class AddPopuliationToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :population, :integer, null: false
  end
end
