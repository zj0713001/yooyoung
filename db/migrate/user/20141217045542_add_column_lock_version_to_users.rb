class AddColumnLockVersionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lock_version, :integer, null: false, default: 0
  end
end
