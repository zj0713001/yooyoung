class AddChannelToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :channel, :string
  end
end
