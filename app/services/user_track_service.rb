class UserTrackService
  include Singleton

  def generate(user, cookies={})
    user_track_id = cookies[:user_track_id].to_s
    if user_track_id.present?
      user_track_from_cookie = UserTrack.find_or_create_by(_id: user_track_id)
    else
      user_track_from_cookie = UserTrack.create
    end

    if user.present?
      user_track = UserTrack.find_or_create_by(user_id: user.id)
      if user_track_from_cookie != user_track
        self.migrate(user_track_from_cookie, user_track)
      end
    else
      user_track = user_track_from_cookie
    end
    cookies[:user_track_id] = {
      value: user_track._id,
      httponly: true,
    }
    user_track
  end

  def migrate(from, to)
    from.links.update_all(user_track: to._id)
    from.destroy
  end

  def track(user_track, request)
    user_track.links.create(request: request)
  end
end
