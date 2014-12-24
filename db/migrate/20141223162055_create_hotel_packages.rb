class CreateHotelPackages < ActiveRecord::Migration
  def change
    create_table :hotel_packages do |t|
      t.string :name, null: false
      t.date :start_day
      t.date :end_day
      t.text :description
      t.references :cover_photo
      t.references :hotel
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps

      t.index :hotel_id
    end
  end
end
