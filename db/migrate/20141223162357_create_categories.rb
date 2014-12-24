class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false, unique: true
      t.string :chinese, null: false, unique: true
      t.integer :sequence, default: 0
      t.references :editor
      t.text :description
      t.boolean :published, default: false, null: false
      t.boolean :active, default: true, null: false

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
