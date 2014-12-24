class Country < ActiveRecord::Base
  has_many :cities, -> { where active: true }
  has_many :hotels, through: :cities
  belongs_to :area
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: -> { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: -> { self.active }
  validates :area, existence: true
  validates :editor, existence: true
end
