class Teams::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_onboarded!

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

  private

  def ensure_onboarded!
    return unless user_signed_in?
    unless current_user.onboarded?
      redirect_to onboarding_path
      false
    end
    true
  end
end
