class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name, null: false, unique: true
      t.string :resource, null: false
      t.integer :action, null: false
      t.references :editor
      t.boolean :active, default: true, null: false

      t.index [:resource, :action], unique: true
      t.index [:action, :resource], unique: true

      t.integer :lock_version, null: false, default: 0
      t.timestamps

    end
  end
end
