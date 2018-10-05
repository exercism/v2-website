require "application_system_test_case"

class OnboardingTest < ApplicationSystemTestCase
  test "onboarding an old user" do
    user = create(:user, created_at: Exercism::V2_MIGRATED_AT - 1.year)
    user.confirm

    visit new_user_session_path
    fill_in "Email address", with: user.email
    fill_in "Password", with: user.password
    within "form" do
      click_on "Log in"
    end
    check "user_accepted_terms_at"
    check "user_accepted_privacy_policy_at"
    click_on "Save and continue to Exercism"

    assert_text "Language tracks"
  end
end
