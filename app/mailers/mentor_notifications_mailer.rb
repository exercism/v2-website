class MentorNotificationsMailer < ApplicationMailer
  add_template_helper(UserHelper)

  def new_discussion_post(mentor, discussion_post)
    @solution = discussion_post.solution
    mail(subject: "[Exercism Mentor Notification] New comment", to: mentor.email)
  end

  def new_iteration(mentor, iteration)
    @solution = iteration.solution
    mail(subject: "[Exercism Mentor Notification] New iteration", to: mentor.email)
  end
end
