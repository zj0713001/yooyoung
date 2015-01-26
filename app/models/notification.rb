class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :channel, type: String
  field :notification_type, type: String
  field :title, type: String, default: :manual
  field :success, type: Boolean
  field :successed_at, type: Time
  field :user_id, type: Integer
  field :identifier, type: String
  field :editor_id, type: Integer
  field :content, type: String
  field :remark, type: String

  scope :channel, ->(channel){ where channel: channel }
  scope :title, ->(title=:manual){ where title: title }

  CHANNELS = %w[
    sms
    email
    phone
  ]
end
