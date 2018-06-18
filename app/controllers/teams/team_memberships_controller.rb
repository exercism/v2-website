class Teams::TeamMembershipsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    team_membership = TeamMembership.
      where(team_id: current_user.managed_teams.pluck(:id)).
      find(params[:id])

    team_membership.destroy

    redirect_to teams_team_memberships_path(team_membership.team)
  end
end
