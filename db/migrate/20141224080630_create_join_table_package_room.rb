class CreateJoinTablePackageRoom < ActiveRecord::Migration
  def up
    remove_column :rooms, :package_id
    create_join_table :hotel_packages, :rooms do |t|
      t.index [:hotel_package_id, :room_id], unique: true
      t.index [:room_id, :hotel_package_id], unique: true
    end
  end

  def down
    drop_table :hotel_packages_rooms
    add_column :rooms, :package_id, :integer
  end
end
