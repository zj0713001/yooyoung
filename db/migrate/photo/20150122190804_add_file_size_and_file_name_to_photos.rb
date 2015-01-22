class AddFileSizeAndFileNameToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :file_name, :string
    add_column :photos, :file_size, :string
    add_column :photos, :content_type, :string
  end
end
