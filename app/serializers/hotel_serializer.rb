class HotelSerializer < ActiveModel::Serializer
  attributes :to_param, :name, :chinese, :description, :provisions, :children_provisions, :drawback_provisions, :address, :phone, :checkin, :checkout, :traffics, :arounds, :best_season, :tips, :recommends, :local_address, :visa_tip, :language_tip, :money_tip, :network_tip, :power_tip, :luggage_tip

  has_many :packages, serializer: HotelPackageSerializer
  has_many :rooms
  has_many :extra_services, serializer: HotelExtraServiceSerializer

  def packages
    object.packages.published
  end

  def to_param
    object.to_param
  end
end
