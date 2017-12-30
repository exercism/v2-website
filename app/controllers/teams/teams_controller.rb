class Teams::TeamsController < ApplicationController

  before_action :redirect_if_pending, only: [:show, :edit, :update, :destroy]

  def index
    @teams = current_user.teams
    @pending_team_memberships = current_user.pending_team_memberships.includes(:team)
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

  private

  def redirect_if_pending
    pending_membership = current_user.pending_team_memberships.where(team_id: params[:id]).first
    if pending_membership
      redirect_to [:teams, pending_membership]
    end
  end
end
