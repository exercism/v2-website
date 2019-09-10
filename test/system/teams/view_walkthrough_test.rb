require_relative "./test_case"

class Teams::WalkthroughTest < Teams::TestCase
  test "user views walkthrough from the team solutions page" do
    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")

    user = create(:user, :onboarded)
    create(:auth_token, user: user)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)

    stub_repo_cache! do
      sign_in!(user)
      visit teams_team_my_solution_path(team, solution)
      click_on "Begin walk-through"
    end

    assert_text "Welcome to the Exercism installation guide!"
  end
end
