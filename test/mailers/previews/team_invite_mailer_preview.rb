class TeamInviteMailerPreview < ActionMailer::Preview
  def new_user
    TeamInviteMailer.new_user(TeamInvitation.first)
  end

  def existing_user
    TeamInviteMailer.existing_user(TeamInvitation.first)
  end
end
