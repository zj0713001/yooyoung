class Main::PricesController < Main::ApplicationController
  def index
    start_date = params[:start_day].to_date
    @hotel = Hotel.friendly_acquire params[:hotel_id]

    @prices = @hotel.rooms.map do |room|
        package_prices = @hotel.packages.map do |package|
          room_package_price = PriceService.new(room).find_all_by_date(start_date, start_date+(package.days-1).days, price_type: :sale_price)
          package_price = PriceService.new(package).find_by_date(start_date, price_type: :sale_price)
          {
            id: package.id,
            sale_price: room_package_price.sum{|price| price[:sale_price].to_i}+package_price[:sale_price].to_i
          }
        end
        {
          id: room.id,
          prices: {
            package_prices: package_prices,
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
      favorite_price: PriceService.new(@hotel.favorite_package).has_prices? ? PackageService.new(@hotel.favorite_package).min_price_by_date : nil
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
