class Teams::InvitationsController < Teams::BaseController
  def show
    @invitation = TeamInvitation.find_by_token(params[:id])
  end

  def accept
    invitation = TeamInvitation.find_by_token(params[:id])
    CreateTeamMembership.(current_user, invitation.team)

    redirect_to teams_teams_path
  end

  def reject
    invitation = TeamInvitation.find_by_token(params[:id])
    invitation.destroy!

    redirect_to teams_teams_path
  end
end
