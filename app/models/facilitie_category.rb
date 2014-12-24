class FacilitieCategory < ActiveRecord::Base
  has_many :items, -> { where active: true }, class_name: FacilitieItem
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: -> { self.active }
  validates :editor, existence: true
end
