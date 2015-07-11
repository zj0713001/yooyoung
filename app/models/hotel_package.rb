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
#  cover_photo_id :integer
#  days           :integer          default(1), not null
#  published      :boolean          default(FALSE), not null
#  on_saled       :boolean          default(FALSE), not null
#  published_at   :datetime
#  active         :boolean          default(TRUE), not null
#  unpublished_at :datetime
#  deleted_at     :datetime
#  presents       :text(65535)
#  exclusives     :text(65535)
#

class HotelPackage < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable
  include ActiveRecord::Serializeable

  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :rooms, -> { where active: true }, uniq: true
  has_many :items, ->{ order('service_day ASC').order('sequence ASC') }, class_name: HotelPackageItem
  has_many :items_with_out_cover_photo, -> { where("`cover_photo_id` IS NULL").order('sequence ASC') }, class_name: HotelPackageItem
  has_many :items_with_cover_photo, -> { where("`cover_photo_id` IS NOT NULL").order('sequence ASC') }, class_name: HotelPackageItem

  belongs_to :hotel
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['content'].blank? }
  # accepts_nested_attributes_for :rooms, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? && attributes['chinese'].blank? }

  # validates :name, presence: true
  # validates :hotel, existence: true
  # validates :editor, existence: true

  serialize_fields [:presents, :exclusives], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end

  after_save :sequence_items
  def sequence_items
    self.items.group_by(&:service_day).sort.each_with_index do |(day_index, items), index|
      items.each_with_index do |item, index|
        item.sequence = index + 1
        item.save
      end
    end
  end
end
