class Teams::TeamMembershipsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    team_membership = teams_managed_members.find(params[:id])

    team_membership.destroy

    redirect_to teams_team_memberships_path(team_membership.team)
  end

  private

  def teams_managed_members
    TeamMembership.where(team_id: current_user.teams_managed.pluck(:id))
  end
end
