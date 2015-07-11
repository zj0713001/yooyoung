class ChangeHotelAddedServicesToHotelExtraServices < ActiveRecord::Migration
  def change
    rename_table :hotel_added_services, :hotel_extra_services
  end
end
