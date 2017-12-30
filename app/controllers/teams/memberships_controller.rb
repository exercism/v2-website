class Teams::MembershipsController < ::TeamsController
  def index
    @memberships = @team.memberships
    @invitations = @team.invitations
  end
end
