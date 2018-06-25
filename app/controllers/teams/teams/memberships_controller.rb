class Teams::Teams::MembershipsController < Teams::Teams::BaseController
  def index
    @memberships = @team.memberships
    @invitations = @team.invitations
  end
end
