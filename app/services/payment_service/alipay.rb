module PaymentService
  class Alipay
    include Rails.application.routes.url_helpers

    BANKS = {
      'BOCB2C' => '中国银行',
      'ICBCB2C' => '中国工商银行',
      'CMB' => '招商银行',
      'CCB' => '中国建设银行',
      'ABC' => '中国农业银行',
      'SPDB' => '上海浦东发展银行',
      'CIB' => '兴业银行',
      'GDB' => '广发银行',
      'FDB' => '富滇银行',
      'HZCBB2C' => '杭州银行',
      'SHBANK' => '上海银行',
      'NBBANK' => '宁波银行',
      'SPABANK' => '平安银行',
      'POSTGC' => '中国邮政储蓄银行',
      # 'abc1003' => 'visa',
      # 'abc1004' => 'master',
    }

    QRCODE = 'qrcode'

    def initialize(trade, payment = nil)
      @config = Settings.payment.alipay
      @trade = trade
      @payment = payment
    end

    def find_or_init_payment
      @payment = @trade.payments.alipay.sms_nopay.first
      if @payment.blank? || @payment.try(:payment_price) != @trade.payment_price
        now = Time.now
        payment_no = now.to_date.strftime('%Y%m%d') << (now - now.midnight).to_i.to_s.rjust(8, '0')
        @payment = @trade.payments.create(payment_no: payment_no, payment_price: @trade.payment_price)
        @payment.alipay!
      end
      @payment
    end

    def payment
      @payment
    end

    def payment_options(build_params)
      options = {
        service: :create_direct_pay_by_user,
        out_trade_no: @payment.payment_no,
        subject: "#{Settings.yooyoung.name} - #{@trade.hotel.chinese}#{@trade.package.name}",
        body: [@trade.hotel.chinese, @trade.room.chinese, @trade.package.name].join(' - '),
        # total_fee: '0.01', # For Test
        total_fee: @trade.payment_price.to_i,
        payment_type: :'1',
        notify_url: build_params[:notify_url],
        return_url: build_params[:return_url],
        show_url: build_params[:show_url],
      }

      if build_params[:paymethod] == QRCODE
        options.merge!({
          qr_pay_mode: :'2',
        })
      end

      if build_params[:bank].in?(BANKS.keys)
        options.merge!({
          paymethod: :'bankPay',
          defaultbank: build_params[:bank],
        })
      end

      options = PaymentUtilities::Alipay.instance.common_options(options)

      {
        gateway: @config.gateway,
        method: :get,
        options: options,
      }
    end

    def handle_notify(process_params)
      return 'success' if @payment.sms_paid?
      sign = process_params[:sign]
      sign_compute = PaymentUtilities::Alipay.instance.md5(process_params.except(:sign_type, :sign))
      is_sign_match = sign == sign_compute
      is_payment_no_match = @payment.payment_no == process_params[:out_trade_no].to_s
      is_price_match = @payment.payment_price.to_i == process_params[:total_fee].to_i
      is_status_ok = process_params[:trade_status].in?(%w[TRADE_FINISHED TRADE_SUCCESS])
      if is_sign_match && is_payment_no_match && is_price_match && is_status_ok
        response_data = process_params.to_query
        @payment.update_attributes response_data: response_data, trade_number: process_params[:trade_no], buyer_account: process_params[:buyer_email]
        @payment.pay!
        'success'
      else
        'fail'
      end
    end
  end
end
