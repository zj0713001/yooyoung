module PaymentService
  class AlipayWap
    include Rails.application.routes.url_helpers

    def initialize(trade, payment = nil)
      @config = Settings.payment.alipay
      @trade = trade
      @payment = payment
    end

    def find_or_init_payment
      @payment = @trade.payments.alipay_wap.sms_nopay.first
      if @payment.blank? || @payment.try(:payment_price) != @trade.payment_price
        now = Time.now
        payment_no = now.to_date.strftime('%Y%m%d') << (now - now.midnight).to_i.to_s.rjust(8, '0')
        @payment = @trade.payments.create(payment_no: payment_no, payment_price: @trade.payment_price)
        @payment.alipay_wap!
      end
      @payment
    end

    def payment
      @payment
    end

    def payment_options(build_params)
      default_options = {
        format: :"xml",
        v: :"2.0",
        sec_id: :"MD5",
        partner: @config.account,
      }

      auto_options = default_options.merge({
        req_data: "<direct_trade_create_req><subject>#{Settings.yooyoung.name} - #{@trade.hotel.chinese}#{@trade.package.name}</subject><out_trade_no>#{@payment.payment_no}</out_trade_no><total_fee>#{format("%.2f", @trade.payment_price.to_i)}</total_fee><seller_account_name>#{@config.email}</seller_account_name><notify_url>#{CGI::escape(build_params[:notify_url].to_s)}</notify_url><out_user>#{@trade.user.to_param}</out_user><merchant_url>#{CGI::escape(build_params[:show_url].to_s)}</merchant_url><call_back_url>#{CGI::escape(build_params[:return_url].to_s)}</call_back_url></direct_trade_create_req>",
        :service => "alipay.wap.trade.create.direct",
        :req_id => Time.now.to_i,
      })
      auto_options.merge!({
        :sign => PaymentUtilities::Alipay.instance.md5(auto_options),
      })

      action = "http://wappaygw.alipay.com/service/rest.htm"
      response = Timeout::timeout(30){ HTTParty.get("#{action}?#{auto_options.to_query}").body }
      response_hash = Hash[*response.split('&').map{|x|x.split('=')}.flatten]
      verify_sign = response_hash['sign'] == Digest::MD5.hexdigest(response_hash.except('sign').sort.map{|k,v|"#{k}=#{CGI::unescape(v.to_s)}"}.join("&")+@config.key)
      raise YooYoung::VerificationFailure unless verify_sign

      request_token = Nokogiri::XML.parse(CGI::unescape(response_hash["res_data"])).search("request_token").first.content rescue ""
      options = default_options.merge({
        :req_data => "<auth_and_execute_req><request_token>#{request_token}</request_token></auth_and_execute_req>",
        :service => "alipay.wap.auth.authAndExecute",
        :call_back_url => build_params[:return_url],
      })
      options.merge!({
        :sign => PaymentUtilities::Alipay.instance.md5(options),
      })

      {
        gateway: action,
        method: :get,
        options: options,
      }
    end

    def handle_notify(process_params, from: :get)
      return 'success' if @payment.sms_paid?
      sign = process_params[:sign]
      sign_compute = PaymentUtilities::Alipay.instance.md5(process_params.except(:sign_type, :sign))
      is_sign_match = sign == sign_compute
      raise YooYoung::VerificationFailure unless is_sign_match

      success = if from == :get
        handle_get_notify(process_params)
      else
        handle_post_notify(process_params)
      end

      if success
        response_data = process_params.to_query
        @payment.update_attributes response_data: response_data, trade_number: process_params[:trade_no], buyer_account: process_params[:buyer_email]
        @payment.pay!
        'success'
      else
        'fail'
      end
    end

    def handle_get_notify(process_params)
      is_payment_no_match = @payment.payment_no == process_params[:out_trade_no].to_s
      # is_price_match = @payment.payment_price.to_i == process_params[:total_fee].to_i
      is_status_ok = process_params[:result] == 'success'
      # is_payment_no_match && is_price_match && is_status_ok
      is_payment_no_match && is_status_ok
    end

    def handle_post_notify(process_params)
      notify_xml = Nokogiri::XML.parse(process_params[:notify_data])
      notify_trade_no = notify_xml.search('out_trade_no').first.content
      notify_trade_status = notify_xml.search('trade_status').first.content
      notify_trade_price = notify_xml.search('price').first.content.to_s.to_i

      is_payment_no_match = @payment.payment_no == notify_trade_no.to_s
      is_price_match = @payment.payment_price.to_i == notify_trade_price
      is_status_ok = %w(TRADE_FINISHED TRADE_SUCCESS).include?(notify_trade_status)

      is_payment_no_match && is_price_match && is_status_ok
    end
  end
end
