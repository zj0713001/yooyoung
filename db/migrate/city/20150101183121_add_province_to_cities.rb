class AddProvinceToCities < ActiveRecord::Migration
  def change
    add_reference :cities, :province
  end
end
