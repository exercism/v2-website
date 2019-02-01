class Teams::Teams::MembershipsController < Teams::Teams::BaseController
  before_action :check_admin!, only: [:destroy]

  def index
    @memberships = @team.memberships.includes(:user)
    @invitations = @team.invitations
  end

  def destroy
    membership = @team.memberships.find(params[:id])

    membership.destroy

    redirect_to teams_team_memberships_path(@team)
  end
end
