class Main::Mobile::HotelsController < Main::Mobile::ApplicationController
  def index
    authorize! :index, model

    @title = '酒店列表页'
  end

  def show
    @hotel = model.friendly_acquire params[:id]
    authorize! :show, @hotel

    @packages = @hotel.packages.published

    respond_with(@hotel)
  end
end
