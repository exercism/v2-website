class Teams::InvitationsController < TeamsController
  def create
    emails = params[:emails].to_s.split("\n").map(&:strip).compact
    emails.each do |email|
      CreateTeamInvitation.(@team, current_user, email)
    end

    redirect_to [:teams, @team, :memberships]
  end
end
