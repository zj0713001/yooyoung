class RemoveTipPhotoToHotels < ActiveRecord::Migration
  def up
    remove_column :hotels, :tip_photo_id
  end

  def down
    add_column :hotels, :tip_photo_id, :integer
  end
end
