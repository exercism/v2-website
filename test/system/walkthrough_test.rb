require "application_system_test_case"

class WalkthroughTest < ApplicationSystemTestCase
  test "shows walkthrough" do
    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")
    user = create(:user)
    create(:auth_token, user: user)
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    create(:user_track, user: user, track: track)
    exercise = create(:exercise, track: track)
    solution = create(:solution, user: user, exercise: exercise)

    stub_repo_cache! do
      sign_in!(user)
      visit my_solution_path(solution)
      click_on "Begin Walk-Through"

      assert_text "Welcome to the Exercism installation guide!"
    end
  end
end
