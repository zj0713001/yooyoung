class AddTipPhotoIdToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :tip_photo_id, :integer
  end
end
