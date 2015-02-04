class Prices::Price
  include Mongoid::Document
  include Mongoid::Timestamps

  field :target, type: String
  field :target_id, type: Integer
  field :date, type: Date
  field :local_price, type: Float
  field :price_unit, type: String
  field :cost_price, type: Float
  field :sale_price, type: Float

  index({ target: 1, target_id: 1 }, { background: true })
  index({ target: 1, target_id: 1, date: 1 }, { background: true })

  def profit
    self.sale_price - self.cost_price
  end
end
