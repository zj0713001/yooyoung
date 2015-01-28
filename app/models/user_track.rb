class UserTrack
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Integer
  has_many :links, dependent: :delete

  # UserInterface
  module UserInterface
    def user
      User.find_by id: self.user_id
    end
  end
  include UserInterface
end
