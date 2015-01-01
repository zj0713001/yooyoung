class HotelPackage < ActiveRecord::Base
  has_one :cover_photo, as: :target, dependent: :destroy
  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :rooms, -> { where active: true }, uniq: true
  has_many :items, -> { where active: true }, class_name: HotelPackageItem

  # Todo 价格

  belongs_to :hotel
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :hotel, existence: true
  validates :editor, existence: true
end
