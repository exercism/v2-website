class HeartbeatMailer < ApplicationMailer
  def mentor_heartbeat(user, stats, introduction)
    @unsubscribe_key = :email_on_mentor_heartbeat

    @user = user
    @stats = stats
    @introduction = introduction
    mail(to: @user.email, subject: "[Exercism] Weekly mentoring update")
  end
end
