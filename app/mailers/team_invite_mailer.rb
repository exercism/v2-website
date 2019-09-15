class TeamInviteMailer < ApplicationMailer
  def new_user(invitation)
    @invitation = invitation

    mail(
      to: @invitation.email,
      subject: "#{@invitation.inviter_name} has invited you to join their team on Exercism"
    )
  end

  def existing_user(invitation)
    @invitation = invitation

    mail(
      to: @invitation.email,
      subject: "[Exercism] #{@invitation.inviter_name} has invited you to join their team"
    )
  end
end
