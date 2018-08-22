class Teams::Teams::BaseController < Teams::BaseController
  before_action :find_team

  private

  def current_team_membership
    @current_team_membership ||= current_user.team_memberships.where(team_id: @team.id).first
  end
  helper_method :current_team_membership

  def check_admin!
    unless current_user.managed_teams.include?(@team)
      redirect_to teams_team_path(@team)
    end
  end
end
