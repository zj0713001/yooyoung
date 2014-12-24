class CreateFacilitieItems < ActiveRecord::Migration
  def change
    create_table :facilitie_items do |t|
      t.string :name, null: false

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
