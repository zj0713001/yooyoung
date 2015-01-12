class AddPublishedAt < ActiveRecord::Migration
  def change
    add_column :areas, :published_at, :datetime
    add_column :categories, :published_at, :datetime
    add_column :cities, :published_at, :datetime
    add_column :countries, :published_at, :datetime
    add_column :hotels, :published_at, :datetime
    add_column :provinces, :published_at, :datetime

    add_column :areas, :unpublished_at, :datetime
    add_column :categories, :unpublished_at, :datetime
    add_column :cities, :unpublished_at, :datetime
    add_column :countries, :unpublished_at, :datetime
    add_column :hotels, :unpublished_at, :datetime
    add_column :provinces, :unpublished_at, :datetime
  end
end
