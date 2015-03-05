class AddColumnPackageDayToHotelPackages < ActiveRecord::Migration
  def change
    add_column :hotel_packages, :days, :integer, null: false, default: 1
  end
end
