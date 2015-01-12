class AddActiveAndPublishToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :active, :boolean, default: true, null: false
    add_column :rooms, :published, :boolean, default: false, null: false
    add_column :rooms, :deleted_at, :datetime
    add_column :rooms, :published_at, :datetime
    add_column :rooms, :unpublished_at, :datetime
  end
end
