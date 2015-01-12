class CreateHotelPackageItems < ActiveRecord::Migration
  def change
    create_table :hotel_package_items do |t|
      t.text :contents, null: false
      t.text :description
      t.string :address
      t.text :tips
      t.text :openning_hours
      t.string :phone
      t.references :hotel_package
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps

      t.index :package_id
    end
  end
end
