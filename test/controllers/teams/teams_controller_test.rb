require 'test_helper'

class Teams::TeamsControllerTest < ActionDispatch::IntegrationTest
  test "prevents non-admins from updating team settings" do
    non_admin = create(:user)
    team = create(:team, url_join_allowed: false)
    create(:team_membership,
           user: non_admin,
           team: team,
           admin: false)

    sign_in!(non_admin)
    patch teams_team_url(team),
      params: { team: { url_join_allowed: true } }

    team.reload
    refute team.url_join_allowed?
  end
end
