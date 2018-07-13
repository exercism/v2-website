module NotificationsHelper
  def notification_image(notification)
    case notification.type
    when 'new_discussion_post'
      notification.trigger.user.avatar_url
    when 'new_discussion_post_for_mentor'
      notification.trigger.user.avatar_url
    when 'new_iteration_for_mentor'
      notification.about.user.avatar_url
    end
  end
end
