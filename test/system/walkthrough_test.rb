require "application_system_test_case"

class WalkthroughTest < ApplicationSystemTestCase
  test "shows walkthrough" do
    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")
    user = create(:user, :onboarded)
    create(:auth_token, user: user)
    track = create(:track)
    create(:user_track, user: user, track: track)
    exercise = create(:exercise, track: track)
    solution = create(:solution, user: user, exercise: exercise)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Begin walk-through"

    assert_text "Welcome to the Exercism installation guide!"
  end

  test "shows walkthrough in a different page" do
    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")
    user = create(:user, :onboarded)
    create(:auth_token, user: user)
    track = create(:track)
    create(:user_track, user: user, track: track)
    exercise = create(:exercise, track: track)
    solution = create(:solution, user: user, exercise: exercise)

    sign_in!(user)
    visit walkthrough_my_solution_path(solution)

    assert_text "Welcome to the Exercism installation guide!"
  end
end
