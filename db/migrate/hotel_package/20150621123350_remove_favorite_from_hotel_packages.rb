class RemoveFavoriteFromHotelPackages < ActiveRecord::Migration
  def up
    remove_column :hotel_packages, :favorite
  end

  def down
    add_column :hotel_packages, :favorite, :boolean, null: false
  end
end
