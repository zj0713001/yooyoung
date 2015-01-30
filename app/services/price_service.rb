class PriceService
  def initialize(target)
    @target = target
  end

  def find_by_date(date)
    price = Price.where(target: @target.class.name, target_id: @target.id, date: date).first_or_initialize
    OpenStruct.new({
      local_price: price.local_price.to_f,
      price_unit: price.price_unit,
      cost_price: price.cost_price.to_f,
      sale_price: price.sale_price.to_f,
    })
  end

  def find_all_by_date(start_date, end_date)
    prices = Price.where(target: @target.class.name, target_id: @target.id, :date.gte => start_date, :date.lte => end_date)
    prices.map do |price|
      {
        date: price.date,
        price: OpenStruct.new({
          local_price: price.local_price.to_f,
          price_unit: price.price_unit,
          cost_price: price.cost_price.to_f,
          sale_price: price.sale_price.to_f,
        }),
      }
    end
  end

  def update_by_date(date, local_price: nil, price_unit: nil, cost_price: nil, sale_price: nil)
    price = Price.where(target: @target.class.name, target_id: @target.id, date: date).first_or_initialize
    price.local_price = local_price if local_price.present?
    price.price_unit = price_unit if price_unit.present?
    price.cost_price = cost_price if cost_price.present?
    price.sale_price = sale_price if sale_price.present?
    price.save
  end
end
