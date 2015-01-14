# == Schema Information
#
# Table name: hotel_package_items
#
#  id               :integer          not null, primary key
#  content          :string(255)      not null
#  description      :text
#  address          :string(255)
#  tips             :text
#  openning_hours   :text
#  phone            :string(255)
#  hotel_package_id :integer
#  editor_id        :integer
#  lock_version     :integer          default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#  service_day      :integer
#

class HotelPackageItem < ActiveRecord::Base
  include ActiveRecord::CoverPhotoable
  include ActiveRecord::Serializeable

  has_many :photos, as: :target, dependent: :destroy

  belongs_to :hotel_package, touch: true
  belongs_to :editor, class_name: User

  SERVICE_DAYS = 1..5

  serialize_fields [:openning_hours, :tips], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end
  default_value_for :service_day, 1

  # validates :hotel_package, existence: true
  # validates :editor, existence: true
  validates :service_day, presence: true

  before_save :set_editor
  def set_editor
    self.editor = self.hotel_package.editor
  end
end
