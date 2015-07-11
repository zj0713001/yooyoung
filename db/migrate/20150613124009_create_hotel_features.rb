class CreateHotelFeatures < ActiveRecord::Migration
  def change
    create_table :hotel_features do |t|
      t.string :title, null: false
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
