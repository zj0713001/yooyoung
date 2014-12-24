class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.references :target, polymorphic: true, index: true
      t.references :editor

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
