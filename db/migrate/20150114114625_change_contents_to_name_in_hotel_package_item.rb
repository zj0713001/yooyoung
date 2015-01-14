class ChangeContentsToNameInHotelPackageItem < ActiveRecord::Migration
  def up
    change_column :hotel_package_items, :contents, :string
    rename_column :hotel_package_items, :contents, :content
  end

  def down
    rename_column :hotel_package_items, :content, :contents
    change_column :hotel_package_items, :contents, :text
  end
end
