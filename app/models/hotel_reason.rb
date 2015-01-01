# == Schema Information
#
# Table name: hotel_reasons
#
#  id           :integer          not null, primary key
#  content      :string(255)      not null
#  hotel_id     :integer
#  editor_id    :integer
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class HotelReason < ActiveRecord::Base
  has_many :photos, as: :target, dependent: :destroy

  belongs_to :hotel
  belongs_to :editor, class_name: User

  validates :content, presence: true
  validates :content, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :hotel, existence: true
  validates :editor, existence: true
end
