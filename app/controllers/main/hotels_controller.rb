class Main::HotelsController < Main::ApplicationController
  def index
    @title = '酒店列表页'
  end

  def show
    @title = '酒店详情页'
  end
end
