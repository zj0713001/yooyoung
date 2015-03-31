class Main::Devise::SessionsController < Devise::SessionsController
  def create
    super do
      delete_user_track_from_session
      store_location_for(resource, session[:prev_page])
    end
  end

  def destroy
    super do
      delete_user_track_from_session
    end
  end
end
