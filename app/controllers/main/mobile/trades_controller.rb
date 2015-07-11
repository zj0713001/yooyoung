class Main::Mobile::TradesController < Main::Mobile::ApplicationController
  def index
    authorize! :index, model

    @trades = current_user.trades.order('created_at DESC')
  end

  def show
    @trade = model.find_by_param params[:id]
    authorize! :show, @trade
  end

  def new
    authorize! :create, model

    @hotel = Hotel.friendly_acquire params[:hotel_id]

    min_price_hash = @hotel.packages.map do |package|
      { package => (PackageService.new(package).min_price_by_date.to_i/2.0).ceil }
    end.inject(&:merge)
    @min_price = min_price_hash.to_h.values.compact.min
    can_buy = !@min_price.to_i.zero?

    unless can_buy
      redirect_to @hotel and return
    end

    @trade = model.new
    jsvar.hotel = HotelSerializer.new(@hotel).as_json['hotel']
    jsvar.min_price = @min_price
  end

  def create
    authorize! :create, model

    @trade = model.new
    @success = TradeService.new.create(@trade, trade_params, current_user)

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

  def calendar
    authorize! :create, model

    respond_to do |format|
      format.json {
        render json: {
          status: true,
          data: render_to_string(partial: 'main/mobile/trades/calendar', formats: :html),
        }
      }
    end
  end

  def pay
    @trade = model.find_by_param params[:id]

    authorize! :update, model

    redirect_to @trade and return if !@trade.confirmed?
  end

  def pay_success
    @trade = model.find_by_param params[:id]
    authorize! :show, @trade
  end

  private
  def trade_params
    params.require(:trade).permit(
      :package_id, :room_id, :start_day, :end_day, :people_num, :child_num, :extra_bed_num, :user_remark, extra_services_ids: [],
      communicate_attributes: [:name, :phone, :email],
      attendences_attributes: [:name, :phone],
      user_remark_attributes: [:content],
    )
  end
end
