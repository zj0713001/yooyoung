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

  index({ user_id: 1 }, { background: true, sparse: true })
  index({ identifier: 1 }, { background: true })
  index({ channel: 1 }, { background: true })
  index({ notification_type: 1 }, { background: true })

  scope :channel, ->(channel){ where channel: channel }
  scope :title, ->(title=:manual){ where title: title }

  CHANNELS = %w[
    sms
    email
    phone
  ]
end
