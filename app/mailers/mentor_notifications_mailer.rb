class MentorNotificationsMailer < ApplicationMailer
  def new_discussion_post(user, discussion_post)
    mail(subject: "New discussion post", to: user.email)
  end

  def new_iteration(user, iteration)
    mail(subject: "New iteration created", to: user.email)
  end
end
