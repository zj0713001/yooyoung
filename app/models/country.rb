# == Schema Information
#
# Table name: countries
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  chinese        :string(255)      not null
#  sequence       :integer          default("0")
#  area_id        :integer
#  editor_id      :integer
#  description    :text(65535)
#  published      :boolean          default("0"), not null
#  active         :boolean          default("1"), not null
#  lock_version   :integer          default("0"), not null
#  created_at     :datetime
#  updated_at     :datetime
#  code           :string(255)
#  deleted_at     :datetime
#  published_at   :datetime
#  unpublished_at :datetime
#

class Country < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable

  has_many :cities, -> { where active: true }
  has_many :provinces, -> { where active: true }
  has_many :hotels, through: :cities
  belongs_to :area
  belongs_to :editor, class_name: User

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
end
