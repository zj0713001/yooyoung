class RemoveLocationToHotels < ActiveRecord::Migration
  def up
    remove_column :hotels, :location
  end

  def down
    add_column :hotels, :location, :string
  end
end
