require 'application_system_test_case'

class My::SolutionTest < ApplicationSystemTestCase
  test "command hint fields should be readonly" do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    Git::ExercismRepo.stubs(pages: [])
    @user = create(:user, :onboarded)
    sign_in!(@user)

    exercise = create :exercise
    user_track = create :user_track, user: @user, track: exercise.track
    solution = create(:solution, user: @user, exercise: exercise)
    visit my_solution_path(solution)

    assert find_all("input.download-code").all? { |i| i["readonly"] }
  end

  test "mentored section with auto approve and comment" do
    user = create(:user, :onboarded)

    track_repo_url = "locked_sha"
    locked_sha = "1234"
    latest_sha = "5678"

    locked_exercise_repo = mock
    latest_exercise_repo = mock

    locked_exercise_repo.stubs(
      instructions: "foo",
      test_suite: ['a']
    )
    latest_exercise_repo.stubs(
      instructions: "foo",
      test_suite: ['b']
    )

    track = create :track, repo_url: track_repo_url
    exercise = create :exercise, track: track
    solution = create :solution, user: user, git_sha: locked_sha, git_slug: exercise.slug, exercise: exercise
    iteration = create :iteration, solution: solution
    create(:user_track, track: solution.track, user: user)

    Git::ExercismRepo.stubs(:current_head).with(track_repo_url).returns(latest_sha)
    Git::Exercise.stubs(:new).with(exercise, exercise.slug, locked_sha).returns(locked_exercise_repo)
    Git::Exercise.stubs(:new).with(exercise, exercise.slug, latest_sha).returns(latest_exercise_repo)
    Solution.any_instance.stubs(:track_head).returns(latest_sha)

    sign_in!(user)
    visit my_solution_path(solution)

    refute solution.reload.latest_exercise_version?

    within ".update-exercise-section" do
      click_on "Update exercise to latest version"
    end

    assert solution.reload.latest_exercise_version?
    assert_selector "body.namespace-my.controller-solutions.action-show"
    refute_selector ".update-exercise-section"
  end
end
