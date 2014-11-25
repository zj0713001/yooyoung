class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false, unique: true
      t.integer :space
      t.references :editor
      t.boolean :active, default: true, null: false

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
