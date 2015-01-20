class AddOtherTipsToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :visa_tip, :text
    add_column :hotels, :language_tip, :text
    add_column :hotels, :money_tip, :text
    add_column :hotels, :network_tip, :text
    add_column :hotels, :power_tip, :text
    add_column :hotels, :luggage_tip, :text
  end
end
