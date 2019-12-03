require_relative "./test_case"

module Research
  class UserLogsInToJoinTest < TestCase
    test "user logs in" do
      skip
      user = create(:user,
                    :onboarded,
                    email: "test@example.com",
                    password: "password")
      user.confirm

      visit new_user_session_path
      fill_in "Email address", with: "test@example.com"
      fill_in "Password", with: "password"
      within("form") { click_on "Log in" }

      assert_text "Current Research"
    end
  end
end
