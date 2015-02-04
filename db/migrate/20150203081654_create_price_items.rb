class CreatePriceItems < ActiveRecord::Migration
  def change
    create_table :price_items do |t|
      t.string :name
      t.integer :price
      t.references :price_group, index: true

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
