class TradeService
  def price(trade, price_type)
    package_price = PriceService.new(trade.package).find_by_date(trade.start_day, price_type: price_type)
    room_price = PriceService.new(trade.room).find_all_by_date(trade.start_day, trade.start_day+(trade.package.days-1).days, price_type: price_type)
    room_price_disabled = if trade.package.favorite
      room_price.any?{|d| d[:exist] == false || d[price_type].to_i.zero?} || package_price[:exist] == false || package_price[price_type].to_i.zero?
    else
      room_price.any?{|d| d[:exist] == false || d[price_type].to_i.zero?} || package_price[:exist] == false
    end

    return nil if room_price_disabled == true

    room_price.sum{|price| price[price_type].to_i}+package_price[price_type].to_i+trade.extra_bed_num.to_i*trade.room.extra_bed_price.items.first.price.to_i*trade.package.days.to_i
  end
end
