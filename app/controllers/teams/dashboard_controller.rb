class Teams::DashboardController < Teams::BaseController
  def index
    redirect_to teams_teams_path
  end
end
