class City < ActiveRecord::Base
  has_many :hotels, -> { where active: true }
  belongs_to :country
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :country, existence: true
  validates :editor, existence: true
end
