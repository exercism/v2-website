class TeamInviteMailerPreview < ActionMailer::Preview
  def new_user
    TeamInviteMailer.new_user(TeamInvitation.first)
  end
end
