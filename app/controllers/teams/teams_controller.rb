class Teams::TeamsController < Teams::BaseController
  before_action :find_team, only: [:show, :edit, :update, :update_settings]

  def index
    @teams = current_user.teams
    @invitations = TeamInvitation.for_user(current_user).includes(:team)
  end

  def show
    @team = current_user.teams.find(params[:id])
    @activities = GenerateTeamActivityFeed.(@team)
  end

  def new
    @team = Team.new
  end

  def create
    @team = CreateTeam.(
      current_user,
      params[:team][:name],
      params[:team][:avatar]
    )

    #emails = params[:emails].to_s.split("\n").map(&:strip).compact
    #emails.each do |email|
    #  CreateTeamInvitation.(@team, current_user, email)
    #end

    redirect_to [:teams, @team]
  end

  def edit
  end

  def update
    if @team.admin?(current_user)
      team_params = params.require(:team).permit(:name, :avatar)
      @team.update(team_params)
    end
    redirect_to teams_team_path(@team)
  end

  def update_settings
    if @team.admin?(current_user)
      team_params = params.require(:team).permit(:url_join_allowed)
      @team.update(team_params)
    end
    redirect_to teams_team_memberships_path(@team)
  end

  def find_team
    params[:team_id] = params[:id]
    super
  end

  private

  def team_params
    params.require(:team).permit(:url_join_allowed)
  end
end
