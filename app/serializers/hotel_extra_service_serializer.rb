class HotelExtraServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :keywords, :time, :itineraries
end
