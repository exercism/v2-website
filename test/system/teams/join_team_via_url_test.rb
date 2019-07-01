require "application_system_test_case"

class JoinTeamViaUrlTest < ApplicationSystemTestCase
  test "join team via url" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host
    user = create(:user, :onboarded)
    team = create(:team,
                  token: "TOKEN",
                  url_join_allowed: true,
                  name: "Team A")

    sign_in!(user)
    visit teams_team_join_path("TOKEN")
    click_on "Join team"

    assert_text "Team A"
    team.reload
    assert_includes team.members, user

    Capybara.app_host = original_host
  end
end
