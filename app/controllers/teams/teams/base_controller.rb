class Teams::Teams::BaseController < Teams::BaseController
  before_action :find_team

  private
  def current_team_membership
    @current_team_membership ||= current_user.team_memberships.where(team_id: @team.id).first
  end
  helper_method :current_team_membership
end
