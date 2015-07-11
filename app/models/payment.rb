# == Schema Information
#
# Table name: payments
#
#  id            :integer          not null, primary key
#  trade_id      :integer
#  trade_number  :string(255)
#  buyer_account :string(255)
#  trade_type    :string(255)
#  service_type  :integer
#  response_data :text(65535)
#  status        :integer
#  lock_version  :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#  payment_price :integer
#  payment_no    :string(255)
#  channel       :string(255)
#

class Payment < ActiveRecord::Base
  belongs_to :trade

  enum service_type: {
    manual: 0,
    alipay: 1,
    # unionpay: 2,
    alipay_wap: 3, #TODO
    # alipay_wallet: 4, #TODO
    # unionpay_wap: 5, #TODO
  }

  enum status: {
    sms_nopay: 0,
    sms_paid: 1,
  }

  include AASM
  aasm whiny_transitions: false, requires_new_transaction: false, column: :status, enum: true do
    state :sms_nopay, initial: true
    state :sms_paid

    event :pay do
      transitions from: :sms_nopay, to: :sms_paid do
        after do
          self.trade.pay!
        end
      end
    end
  end

  def to_param
    self.payment_no
  end
end
