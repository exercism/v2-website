module UserHelper
  def display_name(user, user_track = nil)
    if user_track && user_track.anonymous?
      user_track.handle
    else
      if user.profile
        link_to(user.handle, user.profile)
      else
        user.handle
      end
    end
  end

  def display_avatar_url(user, user_track = nil)
    if user_track && user_track.anonymous?
      user_track.avatar_url
    else
      user.avatar_url
    end
  end
end
