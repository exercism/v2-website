class Teams::Teams::MembershipsController < Teams::Teams::BaseController
  before_action :check_admin!, only: [:destroy]

  def index
    @memberships = @team.memberships
    @invitations = @team.invitations
  end

  def destroy
    membership = @team.memberships.find(params[:id])

    membership.destroy

    redirect_to teams_team_memberships_path(@team)
  end

  private

  def check_admin!
    unless current_user.managed_teams.include?(@team)
      redirect_to teams_team_memberships_path(@team)
    end
  end
end
