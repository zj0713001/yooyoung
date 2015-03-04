class AddFileNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :file_name, :string
    add_column :users, :file_size, :string
    add_column :users, :content_type, :string
  end
end
