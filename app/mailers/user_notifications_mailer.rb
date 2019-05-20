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
    subject = if @solution.approved_by_id == User::SYSTEM_USER_ID
        "Your solution to #{track_title}/#{exercise_title} has been automatically approved"
      else
        "A mentor has approved your solution to #{track_title}/#{exercise_title}"
      end
    mail(
      to: @user.email,
      subject: "[Exercism] #{subject}"
    )
  end

  def remind_about_solution(user, solution, other_solutions)
    @unsubscribe_key = :email_on_remind_about_solution

    @user = user
    @solution = solution
    @other_solutions = other_solutions
    mail(
      to: @user.email,
      subject: "[Exercism] Don't forget to continue your Exercism exercise"
    )
  end
end
