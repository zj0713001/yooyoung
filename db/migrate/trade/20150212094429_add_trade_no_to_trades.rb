class AddTradeNoToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :trade_no, :string, null: false, default: ''
    add_index :trades, :trade_no, unique: true
  end
end
