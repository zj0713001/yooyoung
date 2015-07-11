# == Schema Information
#
# Table name: rooms
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  description    :text(65535)
#  features       :text(65535)
#  sight          :string(255)
#  area           :string(255)
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  hotel_id       :integer
#  facilities     :text(65535)
#  active         :boolean          default(TRUE), not null
#  published      :boolean          default(FALSE), not null
#  deleted_at     :datetime
#  published_at   :datetime
#  unpublished_at :datetime
#  population     :integer          not null
#  cover_photo_id :integer
#  bed_type       :string(255)
#  chinese        :string(255)
#  sequence       :integer          default(0)
#

class Room < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable
  include ActiveRecord::Serializeable

  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :hotel_packages, uniq: true
  has_one :child_price, as: :target, class_name: Prices::Child
  has_one :extra_bed_price, as: :target, class_name: Prices::ExtraBed

  belongs_to :hotel
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  serialize_fields [:facilities], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end

  accepts_nested_attributes_for :child_price, allow_destroy: true
  accepts_nested_attributes_for :extra_bed_price, allow_destroy: true
  default_value_for :population, 2

  # validates :name, presence: true

  before_create :build_prices
  def build_prices
    self.build_child_price
    self.build_extra_bed_price
  end
end
