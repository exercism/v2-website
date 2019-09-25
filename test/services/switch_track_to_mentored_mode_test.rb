require 'test_helper'

class SwitchTrackToMentoredModeTest < ActiveSupport::TestCase
  test "noop if tracks aren't accepting students" do
    user = create :user
    track = create :track
    ut = create :user_track, user: user, track: track, independent_mode: nil

    track.update(median_wait_time: 2.weeks)
    SwitchTrackToMentoredMode.(user, track)
    assert_nil ut.reload.independent_mode

    track.update(median_wait_time: 2.days)
    SwitchTrackToMentoredMode.(user, track)
    refute ut.reload.independent_mode
  end

  test "sets one core solutions to have mentoring_requested_at" do
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
    assert core_solution_2.mentoring_requested?
    refute side_solution.mentoring_requested?

    refute core_solution_1.track_in_independent_mode?
    refute core_solution_2.track_in_independent_mode?
    refute side_solution.track_in_independent_mode?
  end

  test "don't set unsubmitted solutions to have mentoring_requested_at" do
    user = create :user
    track = create :track
    core_exercise = create :exercise, track: track, core: true
    core_solution = create :solution, user: user, exercise: core_exercise, mentoring_requested_at: nil, track_in_independent_mode: true
    user_track = create :user_track, user: user, track: track

    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    SwitchTrackToMentoredMode.(user, track)

    [user_track, core_solution].each(&:reload)

    refute user_track.independent_mode?
    refute core_solution.mentoring_requested?
    refute core_solution.track_in_independent_mode?
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
