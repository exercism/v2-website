require 'application_system_test_case'

class Teams::RemoveInviteTest < ApplicationSystemTestCase
  test "team admin removes team invitation" do
    original_host = Capybara.app_host
    Capybara.app_host = "http://teams.lvh.me"

    team_admin = create(:user)
    team = create(:team)
    create(:team_membership, team: team, user: team_admin, admin: true)
    invite = create(:team_invitation, team: team)

    sign_in!(team_admin)
    visit teams_team_memberships_path(team)
    accept_confirm do
      click_on "Remove"
    end

    assert page.has_no_content?("Remove")

    Capybara.app_host = original_host
  end
end
