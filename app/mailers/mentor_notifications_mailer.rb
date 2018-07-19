class MentorNotificationsMailer < ApplicationMailer
  add_template_helper(UserHelper)

  def new_discussion_post(mentor, discussion_post)
    @solution = discussion_post.solution
    exercise_title = @solution.exercise.title
    track_title = @solution.track.title
    mail(subject: "[Exercism Mentor Notification] New comment on #{track_title}/#{exercise_title} - #{@solution.uuid[0,5]}", to: mentor.email)
  end

  def new_iteration(mentor, iteration)
    @solution = iteration.solution
    exercise_title = @solution.exercise.title
    track_title = @solution.track.title
    mail(subject: "[Exercism Mentor Notification] New iteration on #{track_title}/#{exercise_title} - #{@solution.uuid[0,5]}", to: mentor.email)
  end
end
