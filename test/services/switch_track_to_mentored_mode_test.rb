require 'test_helper'

class SwitchTrackToMentoredModeTest < ActiveSupport::TestCase
  test "sets one core solutions to be mentored" do
    user = create :user
    track = create :track
    core_exercise_1 = create :exercise, track: track, core: true
    core_exercise_2 = create :exercise, track: track, core: true
    side_exercise = create :exercise, track: track, core: false

    core_solution_1 = create :solution, user: user, exercise: core_exercise_1, mentoring_requested_at: nil, track_in_independent_mode: true
    core_solution_2 = create :solution, user: user, exercise: core_exercise_2, mentoring_requested_at: nil, track_in_independent_mode: true
    side_solution = create :solution, user: user, exercise: side_exercise, mentoring_requested_at: nil, track_in_independent_mode: true

    create :iteration, solution: core_solution_1
    create :iteration, solution: core_solution_2
    create :iteration, solution: side_solution

    user_track = create :user_track, user: user, track: track

    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    SwitchTrackToMentoredMode.(user, track)

    [user_track, core_solution_1, core_solution_2, side_solution].each(&:reload)

    refute user_track.independent_mode?
    assert core_solution_1.mentoring_requested?
    refute core_solution_2.mentoring_requested?
    refute side_solution.mentoring_requested?

    refute core_solution_1.track_in_independent_mode?
    refute core_solution_2.track_in_independent_mode?
    refute side_solution.track_in_independent_mode?
  end

  test "don't let multiple core solutions be mentored" do
    user = create :user
    track = create :track
    exercise_1 = create :exercise, track: track, core: true
    exercise_2 = create :exercise, track: track, core: true

    solution_1 = create :solution, user: user, exercise: exercise_1, mentoring_requested_at: nil, track_in_independent_mode: true
    solution_2 = create :solution, user: user, exercise: exercise_2, mentoring_requested_at: Time.current, track_in_independent_mode: true

    create :iteration, solution: solution_1
    create :iteration, solution: solution_2

    user_track = create :user_track, user: user, track: track

    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    SwitchTrackToMentoredMode.(user, track)

    [solution_1, solution_2].each(&:reload)

    refute solution_1.mentoring_requested?
    assert solution_2.mentoring_requested?
  end

  test "calls FixUnlockingInUserTrack" do
    git_sha = SecureRandom.uuid
    Git::ExercismRepo.stubs(current_head: git_sha)

    user = create :user
    track = create :track
    user_track = create :user_track, user: user, track: track

    FixUnlockingInUserTrack.expects(:call).with(user_track)
    SwitchTrackToMentoredMode.(user, track)
  end
end
