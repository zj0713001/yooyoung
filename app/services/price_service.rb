class PriceService
  def initialize(target)
    @target = target
  end

  def has_prices?(start_date=Time.now.to_date, end_date=nil)
    options = {
      target: @target.class.name,
      target_id: @target.id,
      :date.gte => start_date,
    }
    options.merge!(:date.lte => end_date) if end_date.present?
    Prices::Price.where(options).exists?
  end

  def find_by_date(date, price_type: nil)
    price_struct(date, find_price(date), price_type)
  end

  def find_all_by_date(start_date, end_date=nil, price_type: nil)
    find_prices(start_date, end_date).map do |data|
      price_struct(data[:date], data[:price], price_type)
    end
  end

  def update_by_date(date, local_price: nil, price_unit: nil, cost_price: nil, sale_price: nil)
    price = Prices::Price.where(target: @target.class.name, target_id: @target.id, date: date).first_or_initialize
    price.local_price = local_price if local_price.present?
    price.price_unit = price_unit if price_unit.present?
    price.cost_price = cost_price if cost_price.present?
    price.sale_price = sale_price if sale_price.present?
    price.save

    price_struct(date, price)
  end

  protected
  def find_price(date)
    Prices::Price.where(target: @target.class.name, target_id: @target.id, date: date).first_or_initialize
  end

  def find_prices(start_date, end_date)
    options = {
      target: @target.class.name,
      target_id: @target.id,
      :date.gte => start_date,
    }
    options.merge!(:date.lte => end_date) if end_date.present?
    prices = Prices::Price.where(options)

    end_date = prices.pluck(:date).max.to_date unless end_date.present?

    (start_date..end_date).map do |date|
      price = prices.where(date: date).first_or_initialize
      { date: date, price: price }
    end
  end


  def price_struct(date, price, price_type=nil)
    struct = {
      local_price: price.try(:local_price),
      price_unit: price.try(:price_unit),
      cost_price: price.try(:cost_price),
      sale_price: price.try(:sale_price),
    }
    if price_type.present?
      {
        date: date,
        price_type => struct[price_type],
        exist: price.persisted?,
      }
    else
      {
        date: date,
        prices: OpenStruct.new(struct).marshal_dump,
        exist: price.persisted?,
      }
    end
  end
end
