class MentorNotificationsMailer < ApplicationMailer
  add_template_helper(UserHelper)

  def new_discussion_post(mentor, discussion_post)
    @unsubscribe_key = :email_on_new_discussion_post_for_mentor
    @user = mentor

    @solution = discussion_post.solution
    exercise_title = @solution.exercise.title
    track_title = @solution.track.title
    mail(subject: "[Exercism Mentor Notification] New comment on #{track_title}/#{exercise_title} - #{@solution.uuid[0,5]}", to: mentor.email)
  end

  def new_iteration(mentor, iteration)
    @unsubscribe_key = :email_on_new_iteration_for_mentor
    @user = mentor

    @solution = iteration.solution
    exercise_title = @solution.exercise.title
    track_title = @solution.track.title
    mail(subject: "[Exercism Mentor Notification] New iteration on #{track_title}/#{exercise_title} - #{@solution.uuid[0,5]}", to: mentor.email)
  end

  def remind(mentor, solution)
    @unsubscribe_key = :email_on_remind_mentor
    @user = mentor

    @solution = solution
    exercise_title = @solution.exercise.title
    track_title = @solution.track.title
    mail(subject: "[Exercism Mentor Reminder] Action required on #{track_title}/#{exercise_title} - #{@solution.uuid[0,5]}", to: mentor.email)
  end
end
