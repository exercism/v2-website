require_relative "./test_case"

class Teams::OnboardingTest < Teams::TestCase
  test "ensures user is onboarded when using teams" do
    user = create(:user)
    team = create(:team)

    sign_in!(user)
    visit teams_team_join_path("TOKEN")

    assert_equal onboarding_path, current_path
  end
end
