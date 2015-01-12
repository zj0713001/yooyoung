# == Schema Information
#
# Table name: hotel_package_items
#
#  id               :integer          not null, primary key
#  contents         :text             not null
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
  has_one :cover_photo, as: :target, dependent: :destroy, class_name: Photo
  has_many :photos, as: :target, dependent: :destroy

  belongs_to :hotel_package
  belongs_to :editor, class_name: User

  SERVICE_DAYS = 1..5

  serialize :contents, Array
  default_value_for :contents, Array.new
  serialize :tips, Array
  default_value_for :tips, Array.new
  serialize :openning_hours, Array
  default_value_for :openning_hours, Array.new
  default_value_for :service_day, 1

  # validates :hotel_package, existence: true
  # validates :editor, existence: true
  validates :service_day, presence: true

  before_save :set_editor
  def set_editor
    self.editor = self.hotel_package.editor
  end
end
