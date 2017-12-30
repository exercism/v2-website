class Teams::DashboardController < TeamsController
  skip_before_action :find_team

  def index
    redirect_to teams_teams_path
  end
end
