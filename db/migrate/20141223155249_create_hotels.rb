class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :name, null: false, unique: true
      t.string :chinese, null: false, unique: true
      t.integer :sequence, default: 0
      t.references :city
      t.references :editor
      t.text :description
      t.text :provision
      t.string :address
      t.string :phone
      t.datetime :checkin
      t.datetime :checkout
      t.text :traffics
      t.references :cover_photo

      t.boolean :published, default: false, null: false
      t.boolean :active, default: true, null: false

      t.integer :lock_version, null: false, default: 0
      t.timestamps

      t.index :name
    end
  end
end
