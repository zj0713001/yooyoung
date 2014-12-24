class CreateFacilitieCategories < ActiveRecord::Migration
  def change
    create_table :facilitie_categories do |t|
      t.string :name, null: false

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
