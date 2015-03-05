class AddProvisionsAndIdentificationToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :children_provisions, :text
    add_column :hotels, :drawback_provisions, :text
    add_column :hotels, :identification, :string
  end
end
