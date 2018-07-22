module NotificationsHelper
  def notification_image(notification)
    case notification.type
    when 'new_discussion_post'
      # Face of the discussion post user
      # trigger = discussion post
      notification.trigger.user.avatar_url

    when 'new_discussion_post_for_mentor'
      # Face of the discussion post user
      # trigger = discussion post
      notification.trigger.user.avatar_url

    when 'new_iteration_for_mentor'
      # Face of the iteration user
      # about = solution
      notification.about.user.avatar_url

    when 'new_reaction'
      # Face of the reacting user
      # trigger = reaction
      notification.trigger.user.avatar_url

    when 'exercise_auto_approved'
      # Your own face
      # about = solution
      notification.about.user.avatar_url

    when 'solution_approved'
      # Your own face
      # about = solution
      notification.about.user.avatar_url
    end
  end
end
