require 'application_system_test_case'

class Teams::AcceptInviteTest < ApplicationSystemTestCase
  test "user accepts invite" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host

    user = create(:user, email: "test@example.com")
    team = create(:team, name: "Team A")
    create(:team_invitation, team: team, email: "test@example.com")

    sign_in!(user)
    visit teams_teams_path
    click_on "Accept"

    assert page.has_link?("Team A")
    assert page.has_no_content?("Pending Invitations")

    Capybara.app_host = original_host
  end
end
