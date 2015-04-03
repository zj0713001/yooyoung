class Main::Mobile::Devise::SessionsController < Main::Mobile::ApplicationController
  def new
    redirect_to mobile_root_path and return if current_user

    @user = User.new
  end
end
