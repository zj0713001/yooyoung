class Main::HomeController < Main::ApplicationController
  layout 'main/home'
  def index
    @title = '主站首页'
  end
end
