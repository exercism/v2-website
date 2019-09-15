require 'test_helper'

class UnPauseUserTrackTest < ActiveSupport::TestCase
  test "unpauses user track" do
    user_track = create :user_track
    exercise = create :exercise, track: user_track.track
    solution = create :solution, exercise: exercise, user: user_track.user
    create :iteration, solution: solution

    PauseUserTrack.(user_track)
    UnpauseUserTrack.(user_track)

    refute user_track.paused?
    refute solution.reload.paused?
  end
end
