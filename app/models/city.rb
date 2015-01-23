# == Schema Information
#
# Table name: cities
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  chinese        :string(255)      not null
#  sequence       :integer          default(0)
#  country_id     :integer
#  editor_id      :integer
#  description    :text
#  published      :boolean          default(FALSE), not null
#  active         :boolean          default(TRUE), not null
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  code           :string(255)
#  province_id    :integer
#  deleted_at     :datetime
#  published_at   :datetime
#  unpublished_at :datetime
#

class City < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable

  has_many :hotels, -> { where active: true }
  belongs_to :country
  belongs_to :province
  belongs_to :editor, class_name: User

  validates :name, uniqueness: { scope: [:country_id, :province_id, :active] }, if: Proc.new { self.active }, allow_blank: true
  validates :chinese, uniqueness: { scope: [:country_id, :province_id, :active] }, if: Proc.new { self.active }, allow_blank: true
  validates :country, existence: true
end
