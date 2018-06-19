class Teams::TeamInvitationsController < ::TeamsController
  skip_before_action :find_team, only: [:accept, :reject]

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
