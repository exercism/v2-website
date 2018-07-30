require "application_system_test_case"

class SolutionsTest < ApplicationSystemTestCase
  test "shows test suite" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    create(:user_track, track: track, user: user)
    exercise = create(:exercise, track: track, slug: "hello-world")
    solution = create(:solution,
                      exercise: exercise,
                      user: user,
                      git_sha: Git::ExercismRepo.current_head(track.repo_url),
                      git_slug: "hello-world")
    iteration = create(:iteration, solution: solution)

    stub_repo_cache! do
      sign_in!(user)
      visit my_solution_path(solution)
    end

    find(:css, ".tab", text: "Test Suite").click
    assert_text "This is the test suite"
  end

  test "index test suite" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    solution = create(:solution, published_at: Time.now)

    sign_in!(user)
    visit track_exercise_solutions_path(solution.track, solution.exercise)
  end
end
