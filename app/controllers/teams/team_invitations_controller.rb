class Teams::TeamInvitationsController < ::TeamsController
  skip_before_action :find_team, only: [:accept]

  def accept
    invite = TeamInvitation.
      for_user(current_user).
      find(params[:id])

    CreateTeamMembership.(current_user, invite.team)

    redirect_to teams_teams_path
  end
end
