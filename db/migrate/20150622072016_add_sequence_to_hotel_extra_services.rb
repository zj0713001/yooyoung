class AddSequenceToHotelExtraServices < ActiveRecord::Migration
  def change
    add_column :hotel_extra_services, :sequence, :integer, default: 0
  end
end
