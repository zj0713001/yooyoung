# == Schema Information
#
# Table name: rooms
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  description    :text
#  features       :text
#  sight          :string(255)
#  area           :string(255)
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  hotel_id       :integer
#  facilities     :text
#  active         :boolean          default(TRUE), not null
#  published      :boolean          default(FALSE), not null
#  deleted_at     :datetime
#  published_at   :datetime
#  unpublished_at :datetime
#  population     :integer          not null
#  cover_photo_id :integer
#  bed_type       :string(255)
#  chinese        :string(255)
#

class Room < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable
  include ActiveRecord::Serializeable

  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :hotel_packages, uniq: true

  belongs_to :hotel
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  serialize_fields [:facilities], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end
  default_value_for :population, 2

  validates :name, presence: true

  before_save :set_hotel_and_editor
  def set_hotel_and_editor
    self.hotel = self.hotel_packages.first.try(:hotel)
    self.editor = self.hotel.try(:editor)
  end
end
