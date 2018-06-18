class TeamInviteMailer < ApplicationMailer
  def new_user(invite)
    @invite = invite

    mail(
      to: @invite.email,
      subject: "#{@invite.inviter_name} has invited you to join Exercism"
    )
  end

  def existing_user(invite)
    @invite = invite

    mail(
      to: @invite.email,
      subject: "#{@invite.inviter_name} has invited you to join their team"
    )
  end
end
