class Main::HotelsController < Main::ApplicationController
  def index
    @title = '酒店列表页'
  end

  def show
    @title = '酒店详情页'
    @hotel = model.acquire params[:id]

    respond_with(@hotel)
  end
end
