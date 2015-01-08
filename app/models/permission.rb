# == Schema Information
#
# Table name: permissions
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  resource     :string(255)      not null
#  action       :string(255)      not null
#  editor_id    :integer
#  active       :boolean          default(TRUE), not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Permission < ActiveRecord::Base
  belongs_to :editor, class_name: User
  has_and_belongs_to_many :roles, -> { where active: true }, uniq: true

  RESOURCES = [
    :user,
    :role,
    :area,
    :category,
    :city,
    :country,
    :hotel,
    :province,
  ]

  ACTIONS = [
    :index,
    :show,
    :create,
    :update,
    :destroy,
    :publish,
  ]
end
