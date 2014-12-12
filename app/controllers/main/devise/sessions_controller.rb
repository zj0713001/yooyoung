class Main::Devise::SessionsController < Devise::SessionsController
  def create
    super do
      delete_user_track_from_session
    end
  end

  def destroy
    super do
      delete_user_track_from_session
    end
  end
end
