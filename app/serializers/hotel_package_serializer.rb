class HotelPackageSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :days, :presents, :exclusives

  has_many :items, serializer: HotelPackageItemSerializer
end
