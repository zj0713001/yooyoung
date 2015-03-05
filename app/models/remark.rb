# == Schema Information
#
# Table name: remarks
#
#  id            :integer          not null, primary key
#  content       :text(65535)
#  target_id     :integer
#  target_type   :string(255)
#  user_id       :integer
#  target_column :string(255)
#

class Remark < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :user
end
