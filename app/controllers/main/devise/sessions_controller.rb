class Main::Devise::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    delete_user_track_from_session
    store_location_for(resource, session[:prev_page])
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def destroy
    super do
      delete_user_track_from_session
    end
  end
end
