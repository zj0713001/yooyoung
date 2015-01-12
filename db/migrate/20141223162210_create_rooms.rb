class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.text :description
      t.text :features
      t.string :sight
      t.string :area

      t.references :package
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
