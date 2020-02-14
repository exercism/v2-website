require_relative "./test_case"

class Research::UserUpdatesThemeTest < Research::TestCase
  test "user updates theme" do
    user = create(:user,
                  :onboarded,
                  joined_research_at: 2.days.ago,
                  dark_code_theme: false)
    solution = create(:research_experiment_solution, user: user)

    sign_in!(user)
    visit research_experiment_solution_path(solution)
    click_on "Dark"

    assert_css "body.prism-dark"
  end
end
