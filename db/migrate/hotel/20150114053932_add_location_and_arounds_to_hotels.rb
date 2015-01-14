class AddLocationAndAroundsToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :location, :string
    add_column :hotels, :arounds, :text
    add_column :hotels, :homepage, :string
    add_column :hotels, :best_season, :string
  end
end
