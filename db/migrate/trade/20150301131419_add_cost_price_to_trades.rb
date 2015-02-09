class AddCostPriceToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :cost_price, :integer
  end
end
