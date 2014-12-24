# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  nickname               :string(255)      default(""), not null
#  phone                  :string(255)      default(""), not null
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  role_id                :integer
#  avatar                 :string(255)
#  lock_version           :integer          default(0), not null
#

class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  include Hashid

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
  validates :nickname, uniqueness: { case_sensitive: false }

  # Ability
  def can? action, resource
    Ability.new(self).can? action, resource rescue false
  end
end
