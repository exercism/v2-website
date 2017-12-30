class Teams::TeamsController < ::TeamsController
  before_action :authenticate_user!
  skip_before_action :find_team, only: [:index, :new, :create]

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
    redirect_to [:teams, @team]
  end

  def find_team
    params[:team_id] = params[:id]
    super
  end
end
