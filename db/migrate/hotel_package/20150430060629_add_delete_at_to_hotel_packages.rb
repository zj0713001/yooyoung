class AddDeleteAtToHotelPackages < ActiveRecord::Migration
  def change
    add_column :hotel_packages, :unpublished_at, :datetime
    add_column :hotel_packages, :deleted_at, :datetime
  end
end
