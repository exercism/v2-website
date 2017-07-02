class DeliversEmail
  def self.deliver(*args)
    new(*args).deliver
  end

  attr_reader :user, :mail_type, :objects, :mailer, :action
  def initialize(user, mail_type, *objects)
    @user = user
    @mail_type = mail_type.to_sym
    @objects = objects
    @mailer, @action = parse_mail_type
  end

  def deliver
    return false unless should_deliver?

    "#{mailer}_mailer".classify.constantize.send(action, user, *objects).deliver
  end

  private

  def parse_mail_type
    case mail_type
    when :new_discussion_post
      [:notifications, :new_discussion_post]
    else
      raises "Unknown mail type"
    end
  end

  # TODO
  def should_deliver?
    true
  end
end

