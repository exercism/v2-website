require 'test_helper'

class Teams::TeamMembershipsControllerTest < ActionDispatch::IntegrationTest
  test "prevents non-admins from removing team members" do
    non_admin = create(:user, :onboarded)
    member = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership,
           user: non_admin,
           team: team,
           admin: false)
    membership = create(:team_membership,
                        user: member,
                        team: team,
                        admin: false)

    sign_in!(non_admin)
    delete teams_team_membership_url(team, membership)

    assert_redirected_to teams_team_path(team)
  end
end
