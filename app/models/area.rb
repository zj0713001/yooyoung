class Area < ActiveRecord::Base
  has_many :countries, -> { where active: true }
  has_many :hotels, through: :countries
  belongs_to :editor, class_name: User
  has_many :photos, as: :target, dependent: :destroy
  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :editor, existence: true
end
