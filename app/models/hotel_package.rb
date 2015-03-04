# == Schema Information
#
# Table name: hotel_packages
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  start_day      :date
#  end_day        :date
#  description    :text(65535)
#  hotel_id       :integer
#  editor_id      :integer
#  created_at     :datetime
#  updated_at     :datetime
#  favorite       :boolean          default("0"), not null
#  cover_photo_id :integer
#  days           :integer          default("1"), not null
#

class HotelPackage < ActiveRecord::Base
  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :rooms, -> { where active: true }, uniq: true
  has_many :items, ->{ order 'sequence ASC' }, class_name: HotelPackageItem
  has_many :items_with_out_cover_photo, -> { where("`cover_photo_id` IS NULL").order('sequence ASC') }, class_name: HotelPackageItem
  has_many :items_with_cover_photo, -> { where("`cover_photo_id` IS NOT NULL").order('sequence ASC') }, class_name: HotelPackageItem

  belongs_to :hotel
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['content'].blank? }
  accepts_nested_attributes_for :rooms, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? && attributes['chinese'].blank? }

  # Todo 价格

  # validates :name, presence: true
  # validates :hotel, existence: true
  # validates :editor, existence: true

  before_save :set_editor
  def set_editor
    self.editor = self.hotel.try(:editor)
  end

  after_save :sequence_items
  def sequence_items
    self.items.each_with_index do |item, index|
      item.sequence = index + 1
      item.save
    end
  end
end
