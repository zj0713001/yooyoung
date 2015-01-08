class Province < ActiveRecord::Base
  belongs_to :country
  belongs_to :editor, class_name: User
  has_many :cities, -> { where active: true }
  has_many :hotels, through: :cities

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :country, existence: true
end
