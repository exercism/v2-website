class Teams::BaseController < ApplicationController
  layout 'teams'
  before_action :authenticate_user!

  def set_site_context
    cookies["site_context"] = {
      value: "teams",
      domain: :all,
      tld_length: 2
    }
  end

  def redirect_if_signed_in!
    redirect_to teams_dashboard_path if user_signed_in?
  end

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
end
