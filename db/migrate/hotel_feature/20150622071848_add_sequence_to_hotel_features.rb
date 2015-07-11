class AddSequenceToHotelFeatures < ActiveRecord::Migration
  def change
    add_column :hotel_features, :sequence, :integer, default: 0
  end
end
