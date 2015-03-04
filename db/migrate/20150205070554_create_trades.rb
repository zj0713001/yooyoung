class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      # prices
      t.integer :total_price
      t.integer :changed_price
      t.integer :preferential_price
      t.integer :payment_price

      # trades_info
      t.references :user, index: true
      t.references :room, index: true
      t.references :hotel, index: true
      t.references :package, index: true
      t.references :communicate, index: true
      t.date :start_day
      t.date :end_day
      t.integer :extra_bed_num
      t.integer :child_num

      # emails
      t.string :book_email
      t.string :book_cc_email

      # state_machine
      t.string :aasm_state

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
