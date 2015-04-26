class DeleteHotelCheatsAndHotelReasons < ActiveRecord::Migration
  def up
    drop_table :hotel_reasons
    drop_table :hotel_cheats
  end

  def down
    create_table :hotel_reasons do |t|
      t.string :content, null: false, unique: true
      t.references :hotel
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps

      t.index :hotel_id
    end

    create_table :hotel_cheats do |t|
      t.string :content, null: false, unique: true
      t.references :hotel
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps

      t.index :hotel_id
    end
  end
end
