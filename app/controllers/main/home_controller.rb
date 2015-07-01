class Main::HomeController < Main::ApplicationController
  include Main::HotelsHelper

  layout 'main/home'
  def index
    @title = '主站首页'

    # Test
    @banner_data = Hotel.where(id: Settings.home.banner).order("FIELD(id,#{Settings.home.banner.join(',')})").map do |hotel|
      {
        image: view_context.image_url(hotel.cover_photo.try(:image).try(:huge).try(:url)),
        package_name: hotel.packages.first.name,
        package_price: PriceService.new(hotel.packages.first).has_prices? ? (PackageService.new(hotel.packages.first).min_price_by_date/2.0).ceil : nil,
        name: hotel.chinese,
        location: hotel_location_text(hotel),
        link: hotel_path(hotel)
      }
    end

    @section_data = Hotel.where(id: Settings.home.section).order("FIELD(id,#{Settings.home.section.join(',')})").map do |hotel|
      {
        image: view_context.image_url(hotel.cover_photo.try(:image).try(:large).try(:url)),
        package_name: hotel.packages.first.name,
        package_price: 0,
        name: hotel.chinese,
        location: hotel_location_text(hotel),
        link: hotel_path(hotel)
      }
    end

    [
      {type: :hotel, view: :horizontal},
      {type: :hotel, view: :'big-square'},
      {type: :hotel, view: :vertical},
      {type: :area, view: :'small-square', color: :yellow, area_name: '巴厘岛'},
      {type: :hotel, view: :horizontal},
      {type: :area, view: :'small-square', color: :green, area_name: '甲米'},
      {type: :hotel, view: :'big-square'},
      {type: :hotel, view: :horizontal},
      {type: :area, view: :'small-square', color: :yellow, area_name: '苏梅岛'},
      {type: :hotel, view: :vertical},
      {type: :area, view: :'small-square', color: :green, area_name: '长白山'},
      {type: :hotel, view: :horizontal},
    ].each_with_index do |option, index|
      @section_data[index].merge! option
    end
  end
end
