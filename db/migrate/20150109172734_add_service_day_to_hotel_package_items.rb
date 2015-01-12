class AddServiceDayToHotelPackageItems < ActiveRecord::Migration
  def change
    add_column :hotel_package_items, :service_day, :integer
  end
end
