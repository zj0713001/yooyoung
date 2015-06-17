class Main::PricesController < Main::ApplicationController
  def index
    start_date = params[:start_day].to_date
    @hotel = Hotel.friendly_acquire params[:hotel_id]
    package_price = PriceService.new(@hotel.package).find_by_date(start_date, price_type: :sale_price)
    favorite_package_price = PriceService.new(@hotel.favorite_package).find_by_date(start_date, price_type: :sale_price)

    @prices = @hotel.rooms.map do |room|
      room_favorite_price = PriceService.new(room).find_all_by_date(start_date, start_date+(@hotel.favorite_package.days-1).days, price_type: :sale_price)
      room_package_price = room_favorite_price.select{|price| price[:date].in?(start_date..(start_date+(@hotel.package.days-1).days))}
      {
        id: room.id,
        package_disabled: room_package_price.any?{|d| d[:exist] == false || d[:sale_price].to_i.zero?} || package_price[:exist] == false,
        package_prices: {
          sale_price: room_package_price.sum{|price| price[:sale_price].to_i}+package_price[:sale_price].to_i,
          extra_bed_price: room.extra_bed_price,
          child_price: room.child_price,
        },
        favorite_package_disabled: room_favorite_price.any?{|d| d[:exist] == false || d[:sale_price].to_i.zero?} || favorite_package_price[:exist] == false || favorite_package_price[:sale_price].to_i.zero?,
        favorite_package_prices: {
          sale_price: room_favorite_price.sum{|price| price[:sale_price].to_i}+favorite_package_price[:sale_price].to_i,
          extra_bed_price: room.extra_bed_price,
          child_price: room.child_price,
        },
      }
    end

    respond_to do |format|
      format.json {
        render json: {
          status: true,
          data: @prices,
        }
      }
    end
  end

  def package_min_price
    @hotel = Hotel.friendly_acquire params[:id]
    @prices = {
      # package_price: PriceService.new(@hotel.package).has_prices? ? PackageService.new(@hotel.package).min_price_by_date : nil,
      favorite_price: PriceService.new(@hotel.favorite_package).has_prices? ? (PackageService.new(@hotel.favorite_package).min_price_by_date/2.0).ceil : nil
    }

    respond_to do |format|
      format.json {
        render json: {
          status: true,
          data: @prices,
        }
      }
    end
  end
end
