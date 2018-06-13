class Teams::JoinsController < TeamsController
  skip_before_action :find_team

  def show
    team = Team.find_by!(token: params[:team_token], url_join_allowed: true)

    @team_membership = TeamMembership.new(team: team)
  end

  def create
    team = Team.find_by!(token: params[:team_token], url_join_allowed: true)

    TeamMembership.create!(team: team, user: current_user)

    redirect_to teams_team_path(team)
  end
end
