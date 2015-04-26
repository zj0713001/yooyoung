# == Schema Information
#
# Table name: hotel_extra_services
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  description    :text(65535)
#  hotel_id       :integer
#  cover_photo_id :integer
#  editor_id      :integer
#  lock_version   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  sequence       :integer          default(0)
#  keywords       :text(65535)
#  time           :string(255)
#  itineraries    :text(65535)
#  presents       :text(65535)
#  exclusives     :text(65535)
#  tips           :text(65535)
#

class HotelExtraService < ActiveRecord::Base
  include ActiveRecord::Serializeable

  belongs_to :hotel
  belongs_to :cover_photo, dependent: :destroy, class_name: Photo
  belongs_to :editor, class_name: User

  TIMES = %w(全天 半天)

  serialize_fields [:keywords, :presents, :itineraries, :exclusives, :tips], Array do |variables|
    variables.delete_if{|variable| variable.blank?}
  end
end
