# == Schema Information
#
# Table name: cities
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  chinese      :string(255)      not null
#  sequence     :integer          default(0)
#  country_id   :integer
#  editor_id    :integer
#  description  :text
#  published    :boolean          default(FALSE), not null
#  active       :boolean          default(TRUE), not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  code         :string(255)
#

class City < ActiveRecord::Base
  has_many :hotels, -> { where active: true }
  belongs_to :country
  belongs_to :province
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :country, existence: true
end
