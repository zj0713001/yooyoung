class Permission < ActiveRecord::Base
  belongs_to :editor, class_name: User
  has_and_belongs_to_many :roles, uniq: true

  RESOURCES = [
    :user,
    :role,
  ]
end
