class AddCoverPhotoToHotels < ActiveRecord::Migration
  def change
    add_reference :hotels, :cover_photo
    add_reference :hotel_packages, :cover_photo
    add_reference :hotel_package_items, :cover_photo
    add_reference :rooms, :cover_photo
  end
end
