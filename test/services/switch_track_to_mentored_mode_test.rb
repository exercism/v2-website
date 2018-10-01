require 'test_helper'

class SwitchTrackToMentoredModeTest < ActiveSupport::TestCase
  test "sets core solutions to be mentored" do
    user = create :user
    track = create :track
    core_exercise = create :exercise, track: track, core: true
    side_exercise = create :exercise, track: track, core: false

    core_solution = create :solution, user: user, exercise: core_exercise, mentoring_requested_at: nil, track_in_independent_mode: true
    side_solution = create :solution, user: user, exercise: side_exercise, mentoring_requested_at: nil, track_in_independent_mode: true

    user_track = create :user_track, user: user, track: track

    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    SwitchTrackToMentoredMode.(user, track)

    [user_track, core_solution, side_solution].each(&:reload)

    refute user_track.independent_mode?
    assert core_solution.mentoring_requested?
    refute side_solution.mentoring_requested?

    refute core_solution.track_in_independent_mode?
    refute side_solution.track_in_independent_mode?
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
