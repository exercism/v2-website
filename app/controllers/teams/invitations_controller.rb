class Teams::InvitationsController < TeamsController
  skip_before_action :find_team, only: [:accept, :reject]

  def create
    emails = params[:emails].to_s.split("\n").map(&:strip).compact
    emails.each do |email|
      CreateTeamInvitation.(@team, current_user, email)
    end

    redirect_to [:teams, @team, :memberships]
  end

  def accept
    invite = TeamInvitation.
      for_user(current_user).
      find(params[:id])

    CreateTeamMembership.(current_user, invite.team)

    redirect_to teams_teams_path
  end

  def reject
    invite = TeamInvitation.
      for_user(current_user).
      find(params[:id])

    invite.destroy!

    redirect_to teams_teams_path
  end
end
