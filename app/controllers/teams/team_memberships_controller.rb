class Teams::TeamMembershipsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    team_membership = TeamMembership.find(params[:id])

    team_membership.destroy

    redirect_to teams_team_memberships_path(team_membership.team)
  end
end
