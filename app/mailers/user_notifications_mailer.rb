class UserNotificationsMailer < ApplicationMailer
  def new_discussion_post(user, discussion_post)
    @user = user
    @discussion_post = discussion_post
    mail(
      to: @user.email,
      subject: "A mentor has commented on your solution"
    )
  end
end
