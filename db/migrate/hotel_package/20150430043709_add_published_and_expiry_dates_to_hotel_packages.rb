class AddPublishedAndExpiryDatesToHotelPackages < ActiveRecord::Migration
  def change
    add_column :hotel_packages, :published, :boolean, default: false, null: false
    add_column :hotel_packages, :on_saled, :boolean, default: false, null: false
    add_column :hotel_packages, :published_at, :datetime
  end
end
