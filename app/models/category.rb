class Category < ActiveRecord::Base
  belongs_to :editor, class_name: User
  has_and_belongs_to_many :hotels, -> { where active: true }, uniq: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :editor, existence: true
end
