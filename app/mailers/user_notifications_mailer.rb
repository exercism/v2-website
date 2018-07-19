class UserNotificationsMailer < ApplicationMailer
  def new_discussion_post(user, discussion_post)
    @user = user
    @discussion_post = discussion_post
    @solution = discussion_post.solution
    exercise_title = @solution.exercise.title
    track_title = @solution.track.title
    mail(
      to: @user.email,
      subject: "[Exercism] A mentor has commented on your solution to #{track_title}/#{exercise_title}"
    )
  end
end
