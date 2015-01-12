class AddFavoriteToHotelPackages < ActiveRecord::Migration
  def change
    add_column :hotel_packages, :favorite, :boolean, null: false, default: false
  end
end
