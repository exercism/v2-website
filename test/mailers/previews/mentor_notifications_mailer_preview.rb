# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class MentorNotificationsMailerPreview < ActionMailer::Preview
  def new_discussion_post
    MentorNotificationsMailer.new_discussion_post(User.first, DiscussionPost.first)
  end

  def new_iteration
    MentorNotificationsMailer.new_discussion_post(User.first, Iteration.first)
  end

  def remind
    MentorNotificationsMailer.remind(User.first, Solution.first)
  end
end
