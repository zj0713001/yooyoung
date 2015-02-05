class Contacts::Info < ActiveRecord::Base
  self.table_name = :contacts_infos

  belongs_to :user, class_name: User
end
