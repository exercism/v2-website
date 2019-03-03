class UserNotificationsMailer < ApplicationMailer
  def new_discussion_post(user, discussion_post)
    @unsubscribe_key = :email_on_new_discussion_post

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

  def solution_approved(user, solution)
    @unsubscribe_key = :email_on_solution_approved

    @user = user
    @solution = solution
    exercise_title = @solution.exercise.title
    track_title = @solution.track.title
    mail(
      to: @user.email,
      subject: "[Exercism] A mentor has approved your solution to #{track_title}/#{exercise_title}"
    )
  end
end
