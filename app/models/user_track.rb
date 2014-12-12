class UserTrack
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Integer
  has_many :links, dependent: :delete
end
