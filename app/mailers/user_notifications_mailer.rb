class UserNotificationsMailer < ApplicationMailer
  def new_discussion_post(user, discussion_post)
    @user = user
    @discussion_post = discussion_post
    @solution = discussion_post.solution
    mail(
      to: @user.email,
      subject: "[Exercism] A mentor has commented on your solution"
    )
  end
end
