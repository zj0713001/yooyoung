class CreatePriceGroups < ActiveRecord::Migration
  def change
    create_table :price_groups do |t|
      t.string :type

      t.string :name
      t.integer :limit
      t.references :target, polymorphic: true, index: true

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
