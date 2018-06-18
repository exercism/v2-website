class Teams::JoinsController < TeamsController
  before_action :check_team_membership!
  skip_before_action :find_team

  def show
    @team_membership = TeamMembership.new(team: team)
  end

  def create
    CreateTeamMembership.(current_user, team)

    redirect_to teams_team_path(team)
  end

  private

  def team
    @team ||= Team.find_by!(token: params[:team_token], url_join_allowed: true)
  end

  def check_team_membership!
    redirect_to teams_team_path(team) if team.members.include?(current_user)
  end
end
