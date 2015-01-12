# == Schema Information
#
# Table name: hotel_packages
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  start_day    :date
#  end_day      :date
#  description  :text
#  hotel_id     :integer
#  editor_id    :integer
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class HotelPackage < ActiveRecord::Base
  has_one :cover_photo, as: :target, dependent: :destroy, class_name: Photo
  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :rooms, -> { where active: true }, uniq: true
  has_many :items, class_name: HotelPackageItem

  belongs_to :hotel
  belongs_to :editor, class_name: User

  accepts_nested_attributes_for :items, allow_destroy: true
  accepts_nested_attributes_for :rooms, allow_destroy: true

  # Todo 价格

  validates :name, presence: true
  # validates :hotel, existence: true
  # validates :editor, existence: true

  before_save :set_editor
  def set_editor
    self.editor = self.hotel.editor
  end
end
