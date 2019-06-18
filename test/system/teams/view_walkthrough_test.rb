require 'application_system_test_case'

class Teams::WalkthroughTest < ApplicationSystemTestCase
  test "user views walkthrough from the team solutions page" do
    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")
    original_host = Capybara.app_host
    Capybara.app_host = "http://teams.lvh.me"

    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    create(:auth_token, user: user)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    exercise = create(:exercise, track: track)
    solution = create(:team_solution, team: team, user: user, exercise: exercise)

    stub_repo_cache! do
      sign_in!(user)
      visit teams_team_my_solution_path(team, solution)
      click_on "Begin walk-through"
    end

    assert_text "Welcome to the Exercism installation guide!"

    Capybara.app_host = original_host
  end
end
