# == Schema Information
#
# Table name: hotel_packages
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  start_day      :date
#  end_day        :date
#  description    :text
#  cover_photo_id :integer
#  hotel_id       :integer
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class HotelPackage < ActiveRecord::Base
  has_one :cover_photo, as: :target, dependent: :destroy
  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :rooms, -> { where active: true }, uniq: true
  has_many :items, -> { where active: true }, class_name: HotelPackageItem

  # Todo 价格

  belongs_to :hotel
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :hotel, existence: true
  validates :editor, existence: true
end
