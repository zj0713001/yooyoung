# == Schema Information
#
# Table name: photos
#
#  id           :integer          not null, primary key
#  image        :string(255)
#  target_id    :integer
#  target_type  :string(255)
#  editor_id    :integer
#  lock_version :integer          default("0"), not null
#  created_at   :datetime
#  updated_at   :datetime
#  description  :text(65535)
#  file_name    :string(255)
#  file_size    :string(255)
#  content_type :string(255)
#

class Photo < ActiveRecord::Base
  mount_uploader :image, PhotoUploader
  belongs_to :target, polymorphic: true
  belongs_to :editor, class_name: User

  validates :editor, existence: true
end
