class Main::HotelsController < Main::ApplicationController
  def index
    @title = '酒店列表页'
  end

  def show
    @hotel = model.friendly_acquire params[:id]

    respond_with(@hotel)
  end
end
