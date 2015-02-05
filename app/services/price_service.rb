class PriceService
  def initialize(target)
    @target = target
  end

  def find_by_date(date)
    price = Prices::Price.where(target: @target.class.name, target_id: @target.id, date: date).first_or_initialize
    price_struct(date, price)
  end

  def find_all_by_date(start_date, end_date)
    prices = Prices::Price.where(target: @target.class.name, target_id: @target.id, :date.gte => start_date, :date.lte => end_date)
    (start_date..end_date).map do |date|
      price = prices.where(date: date).first_or_initialize
      price_struct(date, price)
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

  def price_struct(date, price)
    {
      date: date,
      prices: OpenStruct.new({
        local_price: price.try(:local_price),
        price_unit: price.try(:price_unit),
        cost_price: price.try(:cost_price),
        sale_price: price.try(:sale_price),
      }).marshal_dump,
      exist: price.persisted?,
    }
  end
end
