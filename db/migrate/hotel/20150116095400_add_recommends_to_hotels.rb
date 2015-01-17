class AddRecommendsToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :recommends, :text
  end
end
