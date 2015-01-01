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
#  cover_photo_id :integer
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  hotel_id       :integer
#  facilities     :text
#

class Room < ActiveRecord::Base
  has_many :photos, as: :target, dependent: :destroy
  has_and_belongs_to_many :packages, -> { where active: true }, uniq: true

  belongs_to :hotel
  belongs_to :editor, class_name: User

  serialize :features, Array
  default_value_for :features, Array.new
  serialize :facilities, Hash
  default_value_for :facilities, Hash.new

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :packages, existence: true
  validates :hotel, existence: true
  validates :editor, existence: true
end
