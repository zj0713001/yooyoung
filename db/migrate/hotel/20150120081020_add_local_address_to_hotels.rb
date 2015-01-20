class AddLocalAddressToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :local_address, :string
  end
end
