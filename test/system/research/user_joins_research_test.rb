require_relative "./test_case"

module Research
  class UserJoinsResearchTest < TestCase
    test "user joins research" do
      user = create(:user, :onboarded)

      sign_in!(user)
      visit research_join_path
      click_on "Join Research"

      assert_text "Experiments"
    end
  end
end
