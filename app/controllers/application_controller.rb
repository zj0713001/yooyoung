class ApplicationController < ActionController::Base
  layout 'main/application'
  before_action :track_user

  include SimpleCaptcha::ControllerHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:phone, :nickname, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :phone, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:nickname, :password, :password_confirmation, :current_password) }
  end

  def track_user
    user_track_service = UserTrackService.instance
    user_track = session[:user_track] || (session[:user_track] = user_track_service.generate(current_user, cookies))
    user_track_service.track(user_track, request)
  end

  def delete_user_track_from_session
    session.delete :user_track
  end
end
