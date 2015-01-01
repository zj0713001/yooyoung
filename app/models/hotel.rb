class Hotel < ActiveRecord::Base
  has_many :cities, -> { where active: true }
  has_one :cover_photo, as: :target, dependent: :destroy
  has_many :photos, as: :target, dependent: :destroy
  has_many :reasons, -> { where active: true }, class_name: HotelReason
  has_many :cheats, -> { where active: true }, class_name: HotelCheat
  has_and_belongs_to_many :categories, -> { where active: true }, uniq: true

  belongs_to :city
  delegate :area, :country, to: :city, allow_nil: true
  belongs_to :editor, class_name: User

  accepts_nested_attributes_for :cover_photo, reject_if: Proc.new { |attributes| attributes['id'].blank? && attributes['active'] == '0' }
  accepts_nested_attributes_for :photos, reject_if: Proc.new { |attributes| attributes['id'].blank? && attributes['active'] == '0' }

  serialize :traffics, Array
  default_value_for :traffics, Array.new

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :address, presence: true
  validates :provision, presence: true
  validates :cover_photo, presence: true
  validates :city, existence: true
  validates :editor, existence: true
end
