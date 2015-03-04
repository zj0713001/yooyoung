class RemoveAasmStateFromPayments < ActiveRecord::Migration
  def up
    remove_column :payments, :aasm_state
  end
  def down
    add_column :payments, :aasm_state, :string
  end
end
