class Main::PaymentsController < Main::ApplicationController
  protect_from_forgery except: [:notify, :done]

  def new
    authorize! :update, Trade

    @trade = Trade.find_by_param params[:trade_id]

    build_params = {
      host: request.host,
      remote_ip: request.remote_ip,
    }

    case params[:service]
    when 'alipay'
      @payment_service = PaymentService::Alipay.new @trade
      @payment = @payment_service.find_or_init_payment
      build_params.merge!({
        notify_url: notify_trade_payment_url(@trade, @payment),
        return_url: done_trade_payment_url(@trade, @payment),
        show_url: polymorphic_url(@trade.hotel),
      })
      @payment_options = @payment_service.payment_options build_params
    when /alipay_bank_*/
      @payment_service = PaymentService::Alipay.new @trade
      @payment = @payment_service.find_or_init_payment
      @payment.update_attributes channel: params[:service].to_s
      build_params.merge!({
        notify_url: notify_trade_payment_url(@trade, @payment),
        return_url: done_trade_payment_url(@trade, @payment),
        show_url: polymorphic_url(@trade.hotel),
        bank: @payment.channel,
      })
      @payment_options = @payment_service.payment_options build_params
    else
      redirect_to :back and return
    end

    respond_to do |format|
      if @payment_options[:method] == :get
        format.html { redirect_to "#{@payment_options[:gateway]}?#{@payment_options[:options].to_query}" }
      else
        format.html { render template: 'main/payments/post', layout: false }
      end
      format.json {
        render json: { status: true, data: @payment_options }
      }
    end
  end

  def notify
    process_params = params.except(:controller, :action, :trade_id, :id)
    @payment = Payment.find_by payment_no: params[:id]

    @payment_service = PaymentService::Alipay.new @payment.trade, @payment
    notify_response = @payment_service.handle_notify(process_params)

    render text: notify_response, layout: false
  end

  def done
    authorize! :update, Trade

    process_params = params.except(:controller, :action, :trade_id, :id)
    @payment = Payment.find_by payment_no: params[:id]
    @trade = @payment.trade
    @payment_service = PaymentService::Alipay.new @trade, @payment
    notify_response = @payment_service.handle_notify(process_params)

    render 'main/trades/pay_success'
  end
end
