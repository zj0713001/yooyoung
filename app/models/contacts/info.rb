# == Schema Information
#
# Table name: contacts_infos
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  phone        :string(255)      not null
#  email        :string(255)
#  type         :string(255)
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Contacts::Info < ActiveRecord::Base
  self.table_name = :contacts_infos

  belongs_to :user, class_name: User
end
