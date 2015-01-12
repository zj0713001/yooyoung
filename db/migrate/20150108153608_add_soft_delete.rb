class AddSoftDelete < ActiveRecord::Migration
  def change
    add_column :areas, :deleted_at, :datetime
    add_column :categories, :deleted_at, :datetime
    add_column :cities, :deleted_at, :datetime
    add_column :countries, :deleted_at, :datetime
    add_column :hotels, :deleted_at, :datetime
    add_column :provinces, :deleted_at, :datetime
    add_column :roles, :deleted_at, :datetime
  end
end
