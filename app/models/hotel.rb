# == Schema Information
#
# Table name: hotels
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  chinese        :string(255)      not null
#  sequence       :integer          default("0")
#  city_id        :integer
#  editor_id      :integer
#  description    :text(65535)
#  provisions     :text(65535)
#  address        :string(255)
#  phone          :string(255)
#  checkin        :datetime
#  checkout       :datetime
#  traffics       :text(65535)
#  published      :boolean          default("0"), not null
#  active         :boolean          default("1"), not null
#  lock_version   :integer          default("0"), not null
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  published_at   :datetime
#  unpublished_at :datetime
#  arounds        :text(65535)
#  homepage       :string(255)
#  best_season    :string(255)
#  tips           :text(65535)
#  cover_photo_id :integer
#  recommends     :text(65535)
#  local_address  :string(255)
#  visa_tip       :text(65535)
#  language_tip   :text(65535)
#  money_tip      :text(65535)
#  network_tip    :text(65535)
#  power_tip      :text(65535)
#  luggage_tip    :text(65535)
#  slug           :string(255)
#

class Hotel < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable
  include ActiveRecord::Serializeable
  include ActiveRecord::Friendlyable

  has_many :photos, as: :target, dependent: :destroy
  has_one :package, -> { where favorite: false }, class_name: HotelPackage
  delegate :rooms, to: :package, allow_nil: true
  has_one :favorite_package, -> { where favorite: true }, class_name: HotelPackage
  has_many :reasons, -> { where active: true }, class_name: HotelReason
  has_many :cheats, -> { where active: true }, class_name: HotelCheat
  has_and_belongs_to_many :categories, -> { where active: true }, uniq: true

  belongs_to :city
  delegate :area, :country, to: :city, allow_nil: true
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  accepts_nested_attributes_for :package, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :favorite_package, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? }
  serialize_fields [:provisions, :tips, :recommends], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end

  friendlyable :name, :slugged

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  # validates :address, presence: true
  # validates :provisions, presence: true
  validates :city, existence: true
  validates :editor, existence: true

end
