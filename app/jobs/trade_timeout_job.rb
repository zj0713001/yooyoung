class TradeTimeoutJob < ActiveJob::Base
  queue_as :default

  def perform(trade_id)
    trade = Trade.find_by_param trade_id
    if trade.sms_confirmed?
      trade.timeout!
    end
  end
end
