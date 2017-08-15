class MentorNotificationsMailer < ApplicationMailer
  def new_discussion_post(user, discussion_post)
    @solution = discussion_post.solution
    mail(subject: "New discussion post", to: user.email)
  end

  def new_iteration(user, iteration)
    @solution = iteration.solution
    mail(subject: "New iteration created", to: user.email)
  end
end
