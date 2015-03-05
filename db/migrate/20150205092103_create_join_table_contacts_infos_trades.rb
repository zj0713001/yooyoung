class CreateJoinTableContactsInfosTrades < ActiveRecord::Migration
  def change
    create_join_table :contacts_infos, :trades do |t|
      t.index [:contacts_info_id, :trade_id], unique: true
      t.index [:trade_id, :contacts_info_id], unique: true
    end
  end
end
