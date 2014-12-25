class HotelPackageItem < ActiveRecord::Base
  has_one :cover_photo, as: :target, dependent: :destroy
  has_many :photos, as: :target, dependent: :destroy

  belongs_to :package, class_name: HotelPackage
  belongs_to :editor, class_name: User

  serialize :contents, Array
  default_value_for :contents, Array.new
  serialize :tips, Array
  default_value_for :tips, Array.new
  serialize :openning_hours, Array
  default_value_for :openning_hours, Array.new

  validates :contents, presence: true
  validates :contents, uniqueness: { scope: :active }, if: -> { self.active }
  validates :package, existence: true
  validates :editor, existence: true
end
