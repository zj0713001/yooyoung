class AddActiveToHotelPackages < ActiveRecord::Migration
  def change
    add_column :hotel_packages, :active, :boolean, default: true, null: false
  end
end
