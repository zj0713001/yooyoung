# == Schema Information
#
# Table name: hotel_features
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  description    :text(65535)
#  hotel_id       :integer
#  cover_photo_id :integer
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  sequence       :integer          default(0)
#

class HotelFeature < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User
end
