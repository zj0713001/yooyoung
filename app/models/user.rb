class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  def email_required?
    false
  end

  def email_changed?
    email_required?
  end

  belongs_to :role

  validates :phone, presence: true, uniqueness: { case_sensitive: false }, format: { with: TotalRegexp.phone }
  validates :email, uniqueness: { case_sensitive: false }, allow_blank: true, format: { with: TotalRegexp.email }
  validates :nickname, presence: true, uniqueness: { case_sensitive: false }

  # Ability
  def can? action, resource
    Ability.new(self).can? action, resource rescue false
  end
end
