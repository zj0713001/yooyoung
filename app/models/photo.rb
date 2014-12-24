class Photo < ActiveRecord::Base
  mount_uploader :image, PhotoUploader
  belongs_to :target, polymorphic: true
  belongs_to :editor, class_name: User

  validates :editor, existence: true
end
