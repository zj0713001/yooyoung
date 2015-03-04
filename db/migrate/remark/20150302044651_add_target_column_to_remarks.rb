class AddTargetColumnToRemarks < ActiveRecord::Migration
  def change
    add_column :remarks, :target_column, :string
  end
end
