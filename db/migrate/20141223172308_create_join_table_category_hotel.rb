class CreateJoinTableCategoryHotel < ActiveRecord::Migration
  def change
    create_join_table :categories, :hotels do |t|
      t.index [:category_id, :hotel_id], unique: true
      t.index [:hotel_id, :category_id], unique: true
    end
  end
end
