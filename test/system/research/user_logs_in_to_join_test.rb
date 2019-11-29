require "application_system_test_case"

class Research::UserLogsInToJoinTest < ApplicationSystemTestCase
  setup do
    @original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.research_host
  end

  teardown do
    Capybara.app_host = @original_host
  end

  test "user logs in" do
    user = create(:user,
                  :onboarded,
                  email: "test@example.com",
                  password: "password")
    user.confirm

    visit new_user_session_path
    fill_in "Email address", with: "test@example.com"
    fill_in "Password", with: "password"
    within("form") { click_on "Log in" }

    assert_text "Research Section"
  end
end
