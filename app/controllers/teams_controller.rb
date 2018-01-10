class TeamsController < ApplicationController
  layout 'teams'
  before_action :authenticate_user!
  before_action :find_team

  private

  def find_team
    @team = current_user.teams.find(params[:team_id])
  rescue
    invitation = TeamInvitation.for_user(current_user).where(team_id: params[:team_id]).first
    if invitation
      redirect_to [:teams, invitation]
    else
      raise
    end
  end

  def current_team_membership
    @current_team_membership ||= current_user.team_memberships.where(team_id: @team.id).first
  end
  helper_method :current_team_membership

  def set_site_context
    session["site_context"] = "teams"
  end

  def redirect_if_signed_in!
    redirect_to teams_dashboard_path if user_signed_in?
  end
end
