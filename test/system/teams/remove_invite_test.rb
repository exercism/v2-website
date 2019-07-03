require_relative "./test_case"

class Teams::RemoveInviteTest < Teams::TestCase
  test "team admin removes team invitation" do
    team_admin = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: team_admin, admin: true)
    invite = create(:team_invitation, team: team)

    sign_in!(team_admin)
    visit teams_team_memberships_path(team)
    accept_confirm do
      click_on "Remove"
    end

    assert page.has_no_content?("Remove")
  end
end
