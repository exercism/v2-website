# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class UserNotificationsMailerPreview < ActionMailer::Preview
  def new_discussion_post
    UserNotificationsMailer.new_discussion_post(User.first, DiscussionPost.first)
  end
end
