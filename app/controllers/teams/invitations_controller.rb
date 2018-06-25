class Teams::InvitationsController < Teams::BaseController
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

  def destroy
    invitation = TeamInvitation.
      where(team_id: current_user.managed_teams.select(:id)).
      find(params[:id])

    invitation.destroy!

    redirect_to teams_team_memberships_path(invitation.team)
  end
end
