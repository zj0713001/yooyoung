class AddPaymentPriceToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payment_price, :integer
    add_column :payments, :payment_no, :string
  end
end
