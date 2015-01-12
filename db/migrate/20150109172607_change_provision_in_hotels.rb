class ChangeProvisionInHotels < ActiveRecord::Migration
  def change
    rename_column :hotels, :provision, :provisions
  end
end
