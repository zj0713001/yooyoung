class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.text :description
      t.text :features
      t.string :sight
      t.string :area
      t.references :cover_photo
      t.references :package
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps

      t.index :package_id
    end
  end
end
