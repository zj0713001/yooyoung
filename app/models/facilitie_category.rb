# == Schema Information
#
# Table name: facilitie_categories
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class FacilitieCategory < ActiveRecord::Base
  has_many :items, -> { where active: true }, class_name: FacilitieItem
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :editor, existence: true
end
