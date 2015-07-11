class AddInitializationColumnsToHotelExtraServices < ActiveRecord::Migration
  def change
    add_column :hotel_extra_services, :keywords, :text
    add_column :hotel_extra_services, :time, :string
    add_column :hotel_extra_services, :itineraries, :text
    add_column :hotel_extra_services, :presents, :text
    add_column :hotel_extra_services, :exclusives, :text
    add_column :hotel_extra_services, :tips, :text
  end
end
