class DeliversEmail
  class UnknownMailTypeError < RuntimeError
    attr_reader :mail_type
    def initialize(mail_type)
      @mail_type = mail_type
    end
  end

  def self.deliver!(*args)
    new(*args).deliver!
  end

  attr_reader :user, :mail_type, :objects, :mailer, :action
  def initialize(user, mail_type, *objects)
    @user = user
    @mail_type = mail_type.to_sym
    @objects = objects
    @mailer, @action = parse_mail_type
  end

  def deliver!
    return false unless should_deliver?
    mail = "#{mailer}_mailer".classify.constantize.send(action, user, *objects)
    mail.deliver_later
  end

  private

  def parse_mail_type
    case mail_type
    when :new_discussion_post
      [:user_notifications, :new_discussion_post]
    when :new_discussion_post_for_mentor
      [:mentor_notifications, :new_discussion_post]
    when :new_iteration_for_mentor
      [:mentor_notifications, :new_iteration]
    else
      raise UnknownMailTypeError.new(mail_type)
    end
  end

  def should_deliver?
    user.communication_preferences.send("email_on_#{mail_type}")
  end
end
