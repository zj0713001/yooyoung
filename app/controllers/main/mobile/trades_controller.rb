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
    unless PriceService.new(@hotel.package).has_prices?
      redirect_to @hotel and return
    end

    @trade = model.new
    jsvar.hotel = @hotel.as_json
    jsvar.package_min_price = PackageService.new(@hotel.package).min_price_by_date
    jsvar.favorite_min_price = PackageService.new(@hotel.favorite_package).min_price_by_date
  end
end
