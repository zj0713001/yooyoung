# == Schema Information
#
# Table name: hotels
#
#  id                  :integer          not null, primary key
#  name                :string(255)      not null
#  chinese             :string(255)      not null
#  sequence            :integer          default(0)
#  city_id             :integer
#  editor_id           :integer
#  description         :text(65535)
#  provisions          :text(65535)
#  address             :string(255)
#  phone               :string(255)
#  checkin             :datetime
#  checkout            :datetime
#  traffics            :text(65535)
#  published           :boolean          default(FALSE), not null
#  active              :boolean          default(TRUE), not null
#  lock_version        :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  published_at        :datetime
#  unpublished_at      :datetime
#  arounds             :text(65535)
#  homepage            :string(255)
#  best_season         :string(255)
#  tips                :text(65535)
#  cover_photo_id      :integer
#  recommends          :text(65535)
#  local_address       :string(255)
#  visa_tip            :text(65535)
#  language_tip        :text(65535)
#  money_tip           :text(65535)
#  network_tip         :text(65535)
#  power_tip           :text(65535)
#  luggage_tip         :text(65535)
#  slug                :string(255)
#  contact_name        :string(255)
#  contact_phone       :string(255)
#  contact_email       :string(255)
#  trade_email         :string(255)
#  trade_cc_email      :string(255)
#  children_provisions :text(65535)
#  drawback_provisions :text(65535)
#  identification      :string(255)
#

class Hotel < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable
  include ActiveRecord::Serializeable
  include ActiveRecord::Friendlyable
  include Iron::Condition

  has_many :photos, as: :target, dependent: :destroy
  has_many :packages, class_name: HotelPackage
  has_many :features, class_name: HotelFeature
  has_many :extra_services, class_name: HotelExtraService
  has_many :rooms, -> { where active: true }, dependent: :destroy
  # has_and_belongs_to_many :categories, -> { where active: true }, uniq: true

  belongs_to :city
  delegate :area, :country, to: :city, allow_nil: true
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  serialize_fields [:tips, :recommends], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end

  friendlyable :name

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  # validates :address, presence: true
  # validates :provisions, presence: true
  validates :city, existence: true
  validates :editor, existence: true

  def as_json(options = nil)
  super({
    only: [:name, :chinese, :description, :provisions, :children_provisions, :drawback_provisions, :address, :phone, :checkin, :checkout, :traffics, :arounds, :best_season, :tips, :recommends, :local_address, :visa_tip, :language_tip, :money_tip, :network_tip, :power_tip, :luggage_tip],
    include: {
      # cover_photo: {
      #   only: [:image],
      # },
      # photos: {
      #   only: [:image],
      # },
      packages: {
        only: [:id, :name, :description, :days, :presents, :exclusives],
        include: {
          items: {
            only: [:id, :content, :description, :address, :tips, :openning_hours, :phone, :service_day],
          },
        },
      },
      rooms: {
        only: [:id, :name, :description, :features, :sight, :area, :facilities, :population, :bed_type, :chinese],
        include: {
          photos: {
            only: [],
            methods: :normal_narrow_url,
          },
        },
      },
      extra_services: {
        only: [:id, :name, :description, :keywords, :time, :itineraries]
      },
    },
    methods: :to_param,
  }.merge(options.to_h))
end
end
