class AddSequenceToHotelPackageItems < ActiveRecord::Migration
  def change
    add_column :hotel_package_items, :sequence, :integer, default: 0
  end
end
