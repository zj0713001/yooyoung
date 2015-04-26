class AddPresentsAndExclusivesToHotelPackages < ActiveRecord::Migration
  def change
    add_column :hotel_packages, :presents, :text
    add_column :hotel_packages, :exclusives, :text
  end
end
