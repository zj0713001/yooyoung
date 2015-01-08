# == Schema Information
#
# Table name: hotel_package_items
#
#  id             :integer          not null, primary key
#  contents       :text             not null
#  description    :text
#  address        :string(255)
#  tips           :text
#  openning_hours :text
#  phone          :string(255)
#  cover_photo_id :integer
#  package_id     :integer
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class HotelPackageItem < ActiveRecord::Base
  has_one :cover_photo, as: :target, dependent: :destroy
  has_many :photos, as: :target, dependent: :destroy

  belongs_to :package, class_name: HotelPackage
  belongs_to :editor, class_name: User

  serialize :contents, Array
  default_value_for :contents, Array.new
  serialize :tips, Array
  default_value_for :tips, Array.new
  serialize :openning_hours, Array
  default_value_for :openning_hours, Array.new

  validates :contents, presence: true
  validates :contents, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :package, existence: true
  validates :editor, existence: true
end
