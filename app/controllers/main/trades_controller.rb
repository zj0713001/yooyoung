class Main::TradesController < Main::ApplicationController
  def index
    authorize! :index, model

    @trades = current_user.trades.order('created_at DESC')

    @trades = @trades.last_three_months if params[:start_day] == 'months'

    case params[:state]
    when 'process'
      @trades = @trades.sms_submitted
    when 'valid'
      @trades = @trades.sms_confirmed
    when 'paid'
      @trades = @trades.paid
    end
  end

  def show
    @trade = model.find_by_param params[:id]
    authorize! :show, @trade
  end

  def new
    authorize! :create, model

    @hotel = Hotel.friendly_acquire params[:hotel_id]
    unless PriceService.new(@hotel.package).has_prices?
      redirect_to @hotel and return
    end

    @trade = model.new
    jsvar.hotel = @hotel.as_json
    jsvar.package_min_price = PackageService.new(@hotel.package).min_price_by_date
    jsvar.favorite_min_price = PackageService.new(@hotel.favorite_package).min_price_by_date
  end

  def create
    authorize! :create, model

    @trade = model.new
    @trade.attributes = trade_params
    @trade.user = current_user
    extra_bed_num_max = @trade.room.extra_bed_price.limit.to_i
    people_num_max = @trade.room.population.to_i + extra_bed_num_max
    if people_num_max > 0
      @trade.people_num = [@trade.people_num, people_num_max].min
      @trade.extra_bed_num = @trade.people_num - @trade.room.population.to_i
    end
    @trade.child_num = [@trade.child_num, @trade.room.child_price.limit.to_i].min
    @trade.total_price = TradeService.new.price(@trade, :sale_price)
    @trade.cost_price = TradeService.new.price(@trade, :cost_price)
    @trade.user_remark.user = current_user if @trade.user_remark
    @success = @trade.save

    respond_to do |format|
      if @success
        format.html { render :success }
        format.json { render json: { status: true, data: @trade } }
      else
        format.html { render action: :new, hotel_id: @trade.hotel.to_param }
        format.json { raise YooYoung::CreateError }
      end
    end

  end

  def edit
    @trade = model.find_by_param params[:id]
    authorize! :update, @trade

    render :success
  end

  def update
    @trade = model.find_by_param params[:id]
    authorize! :update, @trade

    render :success
  end

  def pay_success
    @trade = model.find_by_param params[:id]
    authorize! :show, @trade

    respond_to do |format|
      if @trade.successed?
        format.html
        format.json { render json: { status: true } }
      else
        format.html { render :show }
        format.json { raise YooYoung::VerificationFailure }
      end
    end
  end

  def destroy
    @trade = model.find_by_param params[:id]
    authorize! :show, @trade

    respond_to do |format|
      if @trade.cancel!
        format.html
        format.json { render json: { status: true } }
      else
        format.html { render :show }
        format.json { raise YooYoung::DeleteError }
      end
    end
  end

  private
  def trade_params
    params.require(:trade).permit(
      :package_id, :room_id, :start_day, :end_day, :people_num, :child_num, :extra_bed_num, :user_remark,
      communicate_attributes: [:name, :phone, :email],
      attendences_attributes: [:name, :phone],
      user_remark_attributes: [:content],
    )
  end
end
