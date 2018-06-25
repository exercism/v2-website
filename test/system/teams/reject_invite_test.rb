require 'application_system_test_case'

class Teams::RejectInviteTest < ApplicationSystemTestCase
  test "user rejects invite" do
    original_host = Capybara.app_host
    Capybara.app_host = "http://teams.lvh.me"

    user = create(:user, email: "test@example.com")
    team = create(:team, name: "Team A")
    create(:team_invitation, team: team, email: "test@example.com")

    sign_in!(user)
    visit teams_teams_path
    accept_confirm do
      click_on "Reject"
    end

    assert page.has_no_content?("Team A")

    Capybara.app_host = original_host
  end
end
