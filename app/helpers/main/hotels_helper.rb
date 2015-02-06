module Main::HotelsHelper
  def hotel_location_text(hotel)
    first_location = hotel.city.try(:province).try(:chinese) || hotel.city.try(:province).try(:name) || hotel.city.try(:country).try(:chinese) || hotel.city.try(:country).try(:name)
    section_location = hotel.city.try(:chinese) || hotel.city.try(:name)
    [first_location, section_location].compact.join('，')
  end
end
