class AddSluggedToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :slug, :string
    add_index :hotels, :slug, unique: true, name: 'by_slug'
  end
end
