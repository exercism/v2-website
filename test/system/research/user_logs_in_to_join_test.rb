require_relative "./test_case"

module Research
  class UserLogsInToJoinTest < TestCase
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

      assert_selector 'h1', text: "Your research area"
    end

    test "user logs in via omniauth" do
      user = create(:user, :onboarded, email: "email@example.org")
      user.confirm
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
        info: {
          name: "New User",
          email: "email@example.org",
          nickname: "newuser",
        }
      })

      visit new_user_session_path
      click_on "with GitHub"

      assert_selector 'h1', text: "Your research area"
    end
  end
end
