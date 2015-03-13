class Main::Mobile::HomeController < Main::Mobile::ApplicationController
  include Main::HotelsHelper

  def index
    @section_data = Hotel.where(id: Settings.home.section).order("FIELD(id,#{Settings.home.section.join(',')})").map do |hotel|
      {
        image: view_context.image_url(hotel.cover_photo.try(:image).try(:large).try(:url)),
        name: hotel.chinese,
        location: hotel_location_text(hotel),
        link: hotel_path(hotel)
      }
    end
  end
end
