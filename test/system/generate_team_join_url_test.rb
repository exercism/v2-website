require "application_system_test_case"

class GenerateTeamJoinUrlTest < ApplicationSystemTestCase
  test "generates a team join url" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host
    team_admin = create(:user, :onboarded)
    team = create(:team, token: "TOKEN", url_join_allowed: false)
    create(:team_membership,
           user: team_admin,
           team: team,
           admin: true)

    sign_in!(team_admin)
    visit teams_team_memberships_path(team)
    check "Allow joining via URL"

    assert_includes(
      find_field("join_url").value,
      teams_team_join_path("TOKEN")
    )
    team.reload
    assert team.url_join_allowed?

    Capybara.app_host = original_host
  end
end
