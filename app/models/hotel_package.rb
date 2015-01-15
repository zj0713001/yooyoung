# == Schema Information
#
# Table name: hotel_packages
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  start_day      :date
#  end_day        :date
#  description    :text
#  hotel_id       :integer
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  favorite       :boolean          default(FALSE), not null
#  cover_photo_id :integer
#

class HotelPackage < ActiveRecord::Base
  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :rooms, -> { where active: true }, uniq: true
  has_many :items, class_name: HotelPackageItem

  belongs_to :hotel
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['content'].blank? }
  accepts_nested_attributes_for :rooms, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? }

  # Todo 价格

  validates :name, presence: true
  # validates :hotel, existence: true
  # validates :editor, existence: true

  before_save :set_editor
  def set_editor
    self.editor = self.hotel.editor
  end
end
