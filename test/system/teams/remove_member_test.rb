require 'application_system_test_case'

class Teams::RemoveMemberTest < ApplicationSystemTestCase
  test "team admin removes member from team" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host

    team_admin = create(:user)
    team = create(:team)
    member = create(:user, name: "Team member")
    create(:team_membership, team: team, user: team_admin, admin: true)
    create(:team_membership, team: team, user: member, admin: false)

    sign_in!(team_admin)
    visit teams_team_memberships_path(team)
    accept_confirm do
      click_on "Remove"
    end

    assert page.has_no_content?("Team member")

    Capybara.app_host = original_host
  end
end
