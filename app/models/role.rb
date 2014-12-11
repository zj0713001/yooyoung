class Role < ActiveRecord::Base
  belongs_to :editor, class_name: User
  has_many :users
  has_and_belongs_to_many :permissions, uniq: true

  scope :active, conditions: { active: true }

  validates :name, presence: true, uniqueness: true

  def deletable?
    self.users.blank?
  end
end
