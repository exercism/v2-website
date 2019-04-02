class DeliverEmail
  include Mandate

  class UnknownMailTypeError < RuntimeError
    attr_reader :mail_type
    def initialize(mail_type)
      @mail_type = mail_type
    end
  end

  attr_reader :user, :mail_type, :objects, :mailer, :action
  def initialize(user, mail_type, *objects)
    @user = user
    @mail_type = mail_type.to_sym
    @objects = objects
    @mailer, @action = parse_mail_type
  end

  def call
    return false unless should_deliver?
    mail = "#{mailer}_mailer".classify.constantize.send(action, user, *objects)
    mail.deliver_later
    update_email_log!
  end

  private

  def update_email_log!
    log = UserEmailLog.for_user(user)
    key = "#{mail_type}_sent_at"
    return unless log.respond_to?(key)

    log.update!(key => Time.current)
  end

  def parse_mail_type
    case mail_type
    when :new_discussion_post
      [:user_notifications, :new_discussion_post]
    when :solution_approved
      [:user_notifications, :solution_approved]

    when :new_discussion_post_for_mentor
      [:mentor_notifications, :new_discussion_post]
    when :new_iteration_for_mentor
      [:mentor_notifications, :new_iteration]
    when :remind_mentor
      [:mentor_notifications, :remind]

    when :new_solution_comment_for_solution_user
      [:solution_comments, :new_comment_for_solution_user]
    when :new_solution_comment_for_other_commenter
      [:solution_comments, :new_comment_for_other_commenter]

    when :mentor_heartbeat
      [:heartbeat, :mentor_heartbeat]

    else
      raise UnknownMailTypeError.new(mail_type)
    end
  end

  def should_deliver?
    user.communication_preferences.try {|cp| cp.send("email_on_#{mail_type}") }
  end
end
