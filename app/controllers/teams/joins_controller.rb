class Teams::JoinsController < TeamsController
  skip_before_action :find_team

  def show
    team = Team.find_by!(token: params[:team_token], url_join_allowed: true)

    @team_membership = TeamMembership.new(team: team)
  end

  def create
    team = Team.find_by!(token: params[:team_token], url_join_allowed: true)

    CreateTeamMembership.(current_user, team)

    redirect_to teams_team_path(team)
  end
end
