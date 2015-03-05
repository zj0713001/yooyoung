class CreateRemarks < ActiveRecord::Migration
  def change
    create_table :remarks do |t|
      t.text :content
      t.references :target, polymorphic: true, index: true
      t.references :user, index: true
    end
  end
end
