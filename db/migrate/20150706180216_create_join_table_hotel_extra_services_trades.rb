class CreateJoinTableHotelExtraServicesTrades < ActiveRecord::Migration
  def change
    create_join_table :hotel_extra_services, :trades do |t|
      t.index [:hotel_extra_service_id, :trade_id], unique: true, name: :extra_id_trade_id
      t.index [:trade_id, :hotel_extra_service_id], unique: true, name: :trade_id_extra_id
    end
  end
end
