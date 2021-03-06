# == Schema Information
#
# Table name: facilitie_items
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class FacilitieItem < ActiveRecord::Base
  belongs_to :category, class_name: FacilitieCategory
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:active, :category] }, if: Proc.new { self.active }
  validates :editor, existence: true
end
