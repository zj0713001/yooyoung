class CreateHotelAddedServices < ActiveRecord::Migration
  def change
    create_table :hotel_added_services do |t|
      t.string :name, null: false
      t.text :description
      t.references :hotel
      t.references :cover_photo
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps

      t.index :hotel_id
    end
  end
end
