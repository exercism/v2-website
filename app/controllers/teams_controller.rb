class TeamsController < ApplicationController
  layout 'teams'

  def set_site_context
    session["site_context"] = "teams"
  end

  def redirect_if_signed_in!
    redirect_to teams_dashboard_path if user_signed_in?
  end
end
