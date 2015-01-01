# == Schema Information
#
# Table name: roles
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  space        :integer
#  editor_id    :integer
#  active       :boolean          default(TRUE), not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Role < ActiveRecord::Base
  belongs_to :editor, class_name: User
  has_many :users
  has_and_belongs_to_many :permissions, -> { where active: true }, uniq: true

  validates :name, presence: true, uniqueness: true

  SPACES = [
    :main,
    :admin,
  ]
  enum space: SPACES

  def deletable?
    self.users.blank?
  end
end
