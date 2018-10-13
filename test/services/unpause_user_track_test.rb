require 'test_helper'

class UnPauseUserTrackTest < ActiveSupport::TestCase
  test "unpauses user track" do
    user_track = create :user_track
    exercise = create :exercise, track: user_track.track
    solution = create :solution, exercise: exercise, user: user_track.user
    create :iteration, solution: solution
    solution_mentorship = create(:solution_mentorship,
           solution: solution,
           requires_action: true)

    PauseUserTrack.(user_track)
    UnpauseUserTrack.(user_track)

    refute user_track.paused?
    refute solution_mentorship.reload.paused?
    assert solution_mentorship.requires_action?
  end
end
