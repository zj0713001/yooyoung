class ApplicationController < ActionController::Base
  layout 'main/application'
  before_action :track_user
  before_action :prev_page
  around_action :handle_xhr_errors, if: ->{ request.format.js? || request.format.json? }

  respond_to :html, :json

  # include SimpleCaptcha::ControllerHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_path, notice: exception.message
  end

  helper_method :model
  def model
    class_name = self.class.name.demodulize
    return if class_name =~ /ApplicationController$/
    @model ||= class_name.remove(/Controller$/).singularize.safe_constantize rescue nil
  end

  helper_method :can?
  def can?(action, model)
    current_user.try(:can?, action, model)
  end

  helper_method :jsvar
  def jsvar
    gon
  end

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

  def handle_xhr_errors
    begin
      yield
    rescue => e
      Rails.logger.error e.inspect
      respond_to do |format|
        format.json { render json: ErrorTable.instance.handle(e.class) }
      end
    end
  end

  def prev_page
    session[:prev_page] = session[:current_page] || root_path
    session[:current_page] = request.fullpath
    jsvar.prev_page = session[:prev_page]
  end

  def flash_message(message, now: false, type: :notice)
    if now
      flash.now[:notice_message] = { type: type, message: message }
    else
      flash[:notice_message] = { type: type, message: message }
    end
  end
end
