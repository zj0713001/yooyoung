class AddEditorIdToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :editor_id, :integer
  end
end
