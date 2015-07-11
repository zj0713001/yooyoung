class HotelPackageItemSerializer < ActiveModel::Serializer
  attributes :id, :content, :description, :address, :tips, :openning_hours, :phone, :service_day
end
