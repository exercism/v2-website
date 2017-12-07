class CreatesNotification
  class UnknownNotificationTypeError < RuntimeError
    attr_reader :type
    def initialize(type)
      @type = type
    end
  end

  VALID_NOTIFICATION_TYPES = %i{
    new_discussion_post
    new_reaction
    new_discussion_post_for_mentor
    new_iteration_for_mentor
    exercise_auto_approved
  }

  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :user, :type, :content, :link, :trigger, :about
  def initialize(user, type, content, link, trigger: nil, about: nil)
    @user = user
    @type = type.to_sym
    @content = content
    @link = link
    @trigger = trigger
    @about = about
  end

  def create!
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
