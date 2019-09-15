require_relative "./test_case"

class JoinTeamViaUrlTest < Teams::TestCase
  test "join team via url" do
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
  end
end
