module UserHelper
  def display_handle(user, user_track = nil)
    if user_track && user_track.anonymous?
      user_track.handle
    else
      user.handle
    end
  end

  def display_handle_link(user, user_track = nil)
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
    avatar_url = if user_track && user_track.anonymous?
        user_track.avatar_url
      else
        user.avatar_url
      end
    avatar_url.present?? avatar_url : "anonymous.png"
  end
end
