class AddTipsToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :tips, :text
  end
end
