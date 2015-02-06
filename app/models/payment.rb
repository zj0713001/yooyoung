class Payment < ActiveRecord::Base
  belongs_to :trade

  enum status: {
    nopay: 0,
    paid: 1,
  }

  enum service_type: {
    manual: 0,
    alipay: 1,
    unionpay: 2,
    alipay_wap: 3, #TODO
    # alipay_wallet: 4, #TODO
    # unionpay_wap: 5, #TODO
  }
end
