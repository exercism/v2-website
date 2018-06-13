class TeamInviteMailer < ApplicationMailer
  def new_user(invite)
    @invite = invite

    mail(
      to: @invite.email,
      subject: "#{@invite.inviter_name} has invited you to join Exercism"
    )
  end
end
