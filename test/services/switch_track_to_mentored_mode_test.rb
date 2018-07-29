require 'test_helper'

class SwitchTrackToMentoredModeTest < ActiveSupport::TestCase
  test "sets uncompleted solutions to independent mode" do
    user = create :user
    track = create :track

    completed_solution = create :solution, user: user, exercise: create(:exercise, track: track), independent_mode: true, completed_at: DateTime.now, track_in_independent_mode: true
    create :iteration, solution: completed_solution

    uncompleted_solution = create :solution, user: user, exercise: create(:exercise, track: track), independent_mode: true, completed_at: nil, track_in_independent_mode: true
    create :iteration, solution: uncompleted_solution

    user_track = create :user_track, user: user, track: track

    SwitchTrackToMentoredMode.(user, track)

    [user_track, completed_solution, uncompleted_solution].each(&:reload)

    refute user_track.independent_mode?
    assert completed_solution.independent_mode?
    assert uncompleted_solution.independent_mode?

    refute completed_solution.track_in_independent_mode?
    refute uncompleted_solution.track_in_independent_mode?
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
