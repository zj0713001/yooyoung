class CreateJoinTablePermissionRole < ActiveRecord::Migration
  def change
    create_join_table :permissions, :roles do |t|
      t.index [:permission_id, :role_id], unique: true
      t.index [:role_id, :permission_id], unique: true
    end
  end
end
