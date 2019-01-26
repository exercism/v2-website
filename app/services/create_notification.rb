class CreateNotification
  include Mandate

  class UnknownNotificationTypeError < RuntimeError
    include Mandate
    initialize_with :type
  end

  # When adding to this list ensure you've also added to:
  # - app/helpers/notifications_helper.rb

  VALID_NOTIFICATION_TYPES = %i{
    exercise_auto_approved
    new_discussion_post
    new_discussion_post_for_mentor
    new_iteration_for_mentor
    solution_approved

    new_blog_comment_for_blog_post_author
    new_blog_comment_for_other_commenter

    new_solution_comment_for_solution_user
    new_solution_comment_for_other_commenter

    new_solution_star
  }

  attr_reader :user, :type, :content, :link, :trigger, :about
  def initialize(user, type, content, link, trigger: nil, about: nil)
    @user = user
    @type = type.to_sym
    @content = content
    @link = link
    @trigger = trigger
    @about = about
  end

  def call
    check_notification_type!

    Notification.create!(
      user: user,
      type: type,
      content: content,
      link: link,
      trigger: trigger,
      about: about,
    )
  end

  private

  def check_notification_type!
    return if VALID_NOTIFICATION_TYPES.include?(type)

    raise UnknownNotificationTypeError.new(type)
  end
end
