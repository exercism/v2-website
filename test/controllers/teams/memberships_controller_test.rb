require 'test_helper'

class Teams::MembershipsControllerTest < ActionDispatch::IntegrationTest
  test "hides settings from non-admins" do
    non_admin = create(:user)
    team = create(:team)
    create(:team_membership,
           user: non_admin,
           team: team,
           admin: false)

    sign_in!(non_admin)
    get teams_team_memberships_url(team)

    assert_select "h2", { count: 0, text: "Settings" }
  end
end
