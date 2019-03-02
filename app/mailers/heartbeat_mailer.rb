class HeartbeatMailer < ApplicationMailer
  def mentor_heartbeat(user, stats, introduction)
    @user = user
    @stats = stats
    @introduction = introduction
    mail(to: @user.email, subject: "[Exercism] Weekly mentoring update")
  end
end
