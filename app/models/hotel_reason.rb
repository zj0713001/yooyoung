class HotelReason < ActiveRecord::Base
  has_many :photos, -> { where active: true }, as: :target

  belongs_to :hotel
  belongs_to :editor, class_name: User

  validates :content, presence: true
  validates :content, uniqueness: { scope: :active }, if: -> { self.active }
  validates :hotel, existence: true
  validates :editor, existence: true
end
