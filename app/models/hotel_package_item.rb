# == Schema Information
#
# Table name: hotel_package_items
#
#  id               :integer          not null, primary key
#  content          :string(255)      not null
#  description      :text(65535)
#  address          :string(255)
#  tips             :text(65535)
#  openning_hours   :text(65535)
#  phone            :string(255)
#  hotel_package_id :integer
#  editor_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  service_day      :integer
#  cover_photo_id   :integer
#

class HotelPackageItem < ActiveRecord::Base
  include ActiveRecord::Serializeable

  has_many :photos, as: :target, dependent: :destroy

  belongs_to :hotel_package
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  SERVICE_DAYS = 1..5

  serialize_fields [:tips], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end
  default_value_for :service_day, 1

  # validates :hotel_package, existence: true
  # validates :editor, existence: true
  validates :service_day, presence: true

  before_save :set_editor
  def set_editor
    self.editor = self.hotel_package.try(:editor)
  end
end
