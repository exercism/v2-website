class Teams::TeamMembershipsController < Teams::BaseController
  def destroy
    team_membership = TeamMembership.
      where(team_id: current_user.managed_teams.select(:id)).
      find(params[:id])

    team_membership.destroy

    redirect_to teams_team_memberships_path(team_membership.team)
  end
end
