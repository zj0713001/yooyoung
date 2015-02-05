class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :trade, index: true
      t.string :trade_number
      t.string :buyer_account
      t.string :trade_type
      t.integer :service_type
      t.text :response_data

      # state_machine
      t.string :aasm_state

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
