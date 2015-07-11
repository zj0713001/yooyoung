class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :features, :sight, :area, :facilities, :population, :bed_type, :chinese

  has_many :photos
end
