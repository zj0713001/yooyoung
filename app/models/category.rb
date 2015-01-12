# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  chinese        :string(255)      not null
#  sequence       :integer          default(0)
#  editor_id      :integer
#  description    :text
#  published      :boolean          default(FALSE), not null
#  active         :boolean          default(TRUE), not null
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  published_at   :datetime
#  unpublished_at :datetime
#

class Category < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include ActiveRecord::Publishable

  belongs_to :editor, class_name: User
  has_and_belongs_to_many :hotels, -> { where active: true }, uniq: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :chinese, presence: true
  validates :chinese, uniqueness: { scope: :active }, if: Proc.new { self.active }
  validates :editor, existence: true
end
