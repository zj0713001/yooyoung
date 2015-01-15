class RemoveLockVersionFromHotelItems < ActiveRecord::Migration
  def up
    remove_column :hotel_packages, :lock_version
    remove_column :hotel_package_items, :lock_version
  end

  def down
    add_column :hotel_package_items, :lock_version, :integer
    add_column :hotel_packages, :lock_version, :integer
  end
end
