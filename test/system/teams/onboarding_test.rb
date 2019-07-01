require "application_system_test_case"

class OnboardingTest < ApplicationSystemTestCase
  test "ensures user is onboarded when using teams" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host
    user = create(:user)
    team = create(:team)

    sign_in!(user)
    visit teams_team_join_path("TOKEN")

    assert_equal onboarding_path, current_path

    Capybara.app_host = original_host
  end
end
