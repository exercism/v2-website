require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  test "instructions and test suite come from git exercise" do
    solution = create :solution
    instructions = mock
    test_suite = mock
    git_exercise = mock(instructions: instructions, test_suite: test_suite)
    Git::Exercise.expects(:new).
                with(solution.exercise, solution.git_slug, solution.git_sha).
                returns(git_exercise)

    assert_equal instructions, solution.instructions
    assert_equal test_suite, solution.test_suite
  end

  test "uuid has no hyphens" do
    solution = create :solution
    refute solution.uuid.include?('-')
  end

  test "returns auto approved" do
    exercise = build(:exercise, auto_approve: true)
    solution = build(:solution, exercise: exercise)

    assert solution.auto_approve?

    exercise = build(:exercise, auto_approve: false)
    solution = build(:solution, exercise: exercise)

    refute solution.auto_approve?
  end

  test "solution is approved when solution is approved" do
    exercise = build(:exercise, auto_approve: false)
    solution = build(:solution, exercise: exercise, approved_by: build(:user))

    assert solution.approved?
  end

  test "active_mentors" do
    solution = create :solution
    active_mentor_on_solution = create :user
    active_mentor_not_on_solution = create :user
    inactive_mentor_on_solution = create :user

    create :solution_mentorship, solution: solution, user: active_mentor_on_solution
    create :solution_mentorship, solution: solution, user: inactive_mentor_on_solution
    create :track_mentorship, user: active_mentor_on_solution
    create :track_mentorship, user: active_mentor_not_on_solution

    assert_equal [active_mentor_on_solution], solution.active_mentors
  end

  test "started vs not_started" do
    user_track = create :user_track
    started_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track)
    create :iteration, solution: started_solution
    unstarted_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track)
    downloaded_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track), downloaded_at: Time.now

    assert_equal [started_solution, downloaded_solution], Solution.started
    assert_equal [unstarted_solution], Solution.not_started
  end

  test "submitted" do
    user_track = create :user_track
    submitted_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track)
    create :iteration, solution: submitted_solution
    unsubmitted_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track)
    downloaded_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track), downloaded_at: Time.now

    assert_equal [submitted_solution], Solution.submitted
  end

  test "has_a_mentor" do
    user_track = create :user_track
    mentored_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track)
    create :solution_mentorship, solution: mentored_solution
    unmentored_solution = create :solution, user: user_track.user, exercise: create(:exercise, track: user_track.track)

    assert_equal [mentored_solution], Solution.has_a_mentor
  end

  test "track_in_mentored_mode" do
    refute create(:solution, track_in_independent_mode: true).track_in_mentored_mode?
    assert create(:solution, track_in_independent_mode: false).track_in_mentored_mode?
  end

  test "display created_at if published_at equals V2 launch date" do
    solution = create :solution, published_at: Exercism::V2_MIGRATED_AT
    assert_equal solution.display_published_at, solution.created_at
  end

  test "display published_at if published_at does not equal V2 launch date" do
    solution = create :solution, published_at: Time.now
    assert_equal solution.display_published_at, solution.published_at
  end

  test "deletes cleanly with associated models" do
    solution = create(:solution)
    create(:solution_lock, solution: solution)
    create(:solution_mentorship, solution: solution)
    create(:ignored_solution_mentorship, solution: solution)
    create(:solution_star, solution: solution)

    solution.destroy!
  end

  test "mentoring_requested?" do
    solution = create :solution, mentoring_requested_at: nil
    refute solution.mentoring_requested?

    solution.update(mentoring_requested_at: Time.current)
    assert solution.mentoring_requested?
  end

  test "latest_exercise_version? with same sha" do
    track_repo_url = "repo_url"
    locked_sha = "1234"

    track = create :track, repo_url: track_repo_url
    exercise = create :exercise, track: track
    solution = create :solution, git_sha: locked_sha, exercise: exercise

    Git::ExercismRepo.expects(:current_head).with(track_repo_url).returns(locked_sha)

    assert solution.latest_exercise_version?
  end

  test "latest_exercise_version? with different sha but same tests" do
    track_repo_url = "locked_sha"
    locked_sha = "1234"
    latest_sha = "5678"

    locked_exercise_repo = mock
    latest_exercise_repo = mock

    test_suite = mock
    locked_exercise_repo.stubs(test_suite: test_suite)
    latest_exercise_repo.stubs(test_suite: test_suite)

    track = create :track, repo_url: track_repo_url
    exercise = create :exercise, track: track
    solution = create :solution, git_sha: locked_sha, git_slug: exercise.slug, exercise: exercise

    Git::ExercismRepo.expects(:current_head).with(track_repo_url).returns(latest_sha)
    Git::Exercise.stubs(:new).with(exercise, exercise.slug, locked_sha).returns(locked_exercise_repo)
    Git::Exercise.stubs(:new).with(exercise, exercise.slug, latest_sha).returns(latest_exercise_repo)

    assert solution.latest_exercise_version?
  end
  test "latest_exercise_version? with different sha and tests" do
    track_repo_url = "locked_sha"
    locked_sha = "1234"
    latest_sha = "5678"

    locked_exercise_repo = mock
    latest_exercise_repo = mock

    locked_exercise_repo.stubs(test_suite: ["foobar"])
    latest_exercise_repo.stubs(test_suite: ["barfoo"])

    track = create :track, repo_url: track_repo_url
    exercise = create :exercise, track: track
    solution = create :solution, git_sha: locked_sha, git_slug: exercise.slug, exercise: exercise

    Git::ExercismRepo.expects(:current_head).with(track_repo_url).returns(latest_sha)
    Git::Exercise.stubs(:new).with(exercise, exercise.slug, locked_sha).returns(locked_exercise_repo)
    Git::Exercise.stubs(:new).with(exercise, exercise.slug, latest_sha).returns(latest_exercise_repo)

    refute solution.latest_exercise_version?
  end

  test "only correct polymorphic iterations are returned" do
    normal_solution = create :solution, id: 1
    team_solution = create :team_solution, id: 1

    normal_iteration = create :iteration, solution: normal_solution
    team_iteration = create :iteration, solution: team_solution

    assert_equal [normal_iteration], normal_solution.iterations
    assert_equal [team_iteration], team_solution.iterations
  end
end
