class FacilitieItem < ActiveRecord::Base
  belongs_to :category, class_name: FacilitieCategory
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:active, :category] }, if: Proc.new { self.active }
  validates :editor, existence: true
end
