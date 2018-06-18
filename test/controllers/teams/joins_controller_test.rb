require 'test_helper'

class Teams::JoinsControllerTest < ActionDispatch::IntegrationTest
  test "redirects to team path if already part of team" do
    user = create(:user)
    team = create(:team)
    create(:team_membership, user: user, team: team)

    sign_in!(user)
    get teams_team_join_url(team.token)

    assert_redirected_to teams_team_path(team)
  end
end
