class Teams::Teams::InvitationsController < Teams::Teams::BaseController
  before_action :check_admin!, only: :destroy

  def create
    emails = params[:emails].to_s.split("\n").map(&:strip).compact
    emails.each do |email|
      CreateTeamInvitation.(@team, current_user, email)
    end

    redirect_to [:teams, @team, :memberships]
  end

  def destroy
    invitation = @team.invitations.find_by_token(params[:id])
    invitation.destroy!

    redirect_to teams_team_memberships_path(invitation.team)
  end
end
