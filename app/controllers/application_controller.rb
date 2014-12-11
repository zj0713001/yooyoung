class ApplicationController < ActionController::Base
  layout 'main/application'

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
end
