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
#  file_name              :string(255)
#  file_size              :string(255)
#  content_type           :string(255)
#

class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  include Hashid
  include Iron::Condition

  has_many :trades
  after_create :generate_other_infos

  def generate_other_infos
    self.role = Role.find 1
    # self.avatar
    self.save
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  scope :by_space, ->(space){ joins(:role).where(Role.arel_table[:space].eq(space))}

  def email_required?
    false
  end

  def email_changed?
    email_required?
  end

  belongs_to :role

  validates :phone, presence: true, uniqueness: { case_sensitive: false }, format: { with: TotalRegexp.phone }
  validates :email, uniqueness: { case_sensitive: false }, allow_blank: true, format: { with: TotalRegexp.email }
  validates :nickname, uniqueness: { case_sensitive: false }, allow_blank: true

  # Ability
  module AbilityInterface
    def can? action, resource
      Ability.new(self).can? action, resource rescue false
    end
  end
  include AbilityInterface

  # UserTrack
  module UserTrackInterface
    def user_track
      UserTrack.find_by user_id: self.id
    end
  end
  include UserTrackInterface

  def as_json(options = nil)
    super({
      only: [:nickname, :phone, :email],
    }.merge(options.to_h))
  end
end
