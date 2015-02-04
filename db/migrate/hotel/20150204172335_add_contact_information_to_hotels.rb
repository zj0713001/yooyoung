class AddContactInformationToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :contact_name, :string
    add_column :hotels, :contact_phone, :string
    add_column :hotels, :contact_email, :string
    add_column :hotels, :trade_email, :string
    add_column :hotels, :trade_cc_email, :string
  end
end
