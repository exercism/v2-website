class Teams::TeamsController < Teams::BaseController
  before_action :find_team, only: [:show, :update]

  def index
    @teams = current_user.teams
    @invitations = TeamInvitation.for_user(current_user).includes(:team)
  end

  def show
    @team = current_user.teams.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = CreateTeam.(
      current_user,
      params[:team][:name]
    )

    emails = params[:emails].to_s.split("\n").map(&:strip).compact
    emails.each do |email|
      CreateTeamInvitation.(@team, current_user, email)
    end

    redirect_to [:teams, @team]
  end

  def update
    @team.update(team_params) if @team.admin?(current_user)

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
