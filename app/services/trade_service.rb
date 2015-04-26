class TradeService
  def price(trade, price_type)
    package_price = PriceService.new(trade.package).find_by_date(trade.start_day, price_type: price_type)
    room_price = PriceService.new(trade.room).find_all_by_date(trade.start_day, trade.start_day+(trade.package.days-1).days, price_type: price_type)
    room_price_disabled = room_price.any?{|d| d[:exist] == false || d[price_type].to_i.zero?} || package_price[:exist] == false

    return nil if room_price_disabled == true

    room_price.sum{|price| price[price_type].to_i}+package_price[price_type].to_i+trade.extra_bed_num.to_i*trade.room.extra_bed_price.items.first.price.to_i*trade.package.days.to_i
  end

  def create(trade, trade_params, user)
    trade.attributes = trade_params
    trade.user = user
    extra_bed_num_max = trade.room.extra_bed_price.limit.to_i
    people_num_max = trade.room.population.to_i + extra_bed_num_max
    if people_num_max > 0
      trade.people_num = [trade.people_num, people_num_max].min
      trade.extra_bed_num = trade.people_num - trade.room.population.to_i
    end
    trade.child_num = [trade.child_num, trade.room.child_price.limit.to_i].min
    trade.total_price = self.price(trade, :sale_price)
    trade.cost_price = self.price(trade, :cost_price)
    trade.user_remark.user = user if trade.user_remark
    trade.save
  end
end
