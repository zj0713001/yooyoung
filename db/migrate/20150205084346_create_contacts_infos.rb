class CreateContactsInfos < ActiveRecord::Migration
  def change
    create_table :contacts_infos do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.string :email
      t.string :type

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
