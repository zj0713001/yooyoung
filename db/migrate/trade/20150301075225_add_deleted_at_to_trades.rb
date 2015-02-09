class AddDeletedAtToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :deleted_at, :datetime
  end
end
