# == Schema Information
#
# Table name: provinces
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  chinese        :string(255)      not null
#  code           :string(255)
#  sequence       :integer          default("0")
#  country_id     :integer
#  editor_id      :integer
#  description    :text(65535)
#  published      :boolean          default("0"), not null
#  active         :boolean          default("1"), not null
#  lock_version   :integer          default("0"), not null
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  published_at   :datetime
#  unpublished_at :datetime
#

class Province < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable
  include Iron::Condition

  belongs_to :country
  belongs_to :editor, class_name: User
  has_many :cities, -> { where active: true }
  has_many :hotels, through: :cities

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:country_id, :active] }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: [:country_id,  :active] }, if: Proc.new { self.active }
  validates :country, existence: true
end
