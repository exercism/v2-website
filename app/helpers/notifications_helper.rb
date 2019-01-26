module NotificationsHelper
  include UserHelper

  def notification_image(notification)
    case notification.type
    when 'new_discussion_post'
      # Face of the discussion post user
      # trigger = discussion post
      notification.trigger.user.avatar_url

    when 'new_discussion_post_for_mentor'
      # Face of the discussion post user
      # trigger = discussion post
      display_avatar_url(notification.trigger.user, notification.trigger.solution.user_track)

    when 'new_iteration_for_mentor'
      # Face of the iteration user
      # about = solution
      display_avatar_url(notification.about.user, notification.about.user_track)

    when 'new_reaction',
         'new_solution_star'
      # Face of the reacting user
      # trigger = reaction
      notification.trigger.user.avatar_url

    when 'exercise_auto_approved'
      # Your own face
      # about = solution
      notification.about.user.avatar_url

    when 'solution_approved'
      # Mentor's face
      # trigger = mentor
      notification.trigger.avatar_url
    end
  rescue
    'blank.gif'
  end
end
