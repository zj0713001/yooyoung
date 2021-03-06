class PackageService
  def initialize(package)
    @package = package
    @hotel = @package.hotel
  end

  def min_price_by_date(start_date = Time.now.to_date)
    end_date = start_date + 1.month

    return nil unless PriceService.new(@package).has_prices?(start_date, end_date)

    package_prices = PriceService.new(@package).find_all_by_date(start_date, end_date, price_type: :sale_price)
    @hotel.rooms.map do |room|
      room_price = PriceService.new(room).find_all_by_date(start_date, (end_date+@package.days), price_type: :sale_price)
      package_prices.map do |data|
        next if !data[:exist]
        room_prices = room_price.select{|d| d[:date].in?( data[:date]..(data[:date]+(@package.days-1).days)) }
        next if room_prices.any?{|d| d[:exist] == false || d[:sale_price].to_i.zero?}
        room_prices.sum{|d| d[:sale_price].to_i} + data[:sale_price].to_i
      end.to_a.compact.to_a.min
    end.to_a.compact.min
  end
end
