module NotificationsHelper
  def notification_icon(notification)
    case notification.type
    when 'new_discussion_post'
      "fa fa-comments"
    when 'new_discussion_post_for_mentor'
    when 'new_iteration_for_mentor'
    end
  end
end
