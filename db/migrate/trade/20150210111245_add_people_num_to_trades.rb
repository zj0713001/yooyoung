class AddPeopleNumToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :people_num, :integer, null: false, default: 2
  end
end
