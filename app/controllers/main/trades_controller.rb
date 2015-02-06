class Main::TradesController < Main::ApplicationController
  def index
  end

  def show
  end

  def new
    @hotel = model.friendly_acquire params[:hotel_id]
    @trade = Trade.new
  end

  def create
  end

  def update
  end
end
