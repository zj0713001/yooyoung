class AddCodeToCountryAndCity < ActiveRecord::Migration
  def change
    add_column :countries, :code, :string
    add_column :cities, :code, :string
  end
end
