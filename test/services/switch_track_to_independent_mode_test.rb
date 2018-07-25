require 'test_helper'

class SwitchTrackToIndependentModeTest < ActiveSupport::TestCase
  test "sets uncompleted solutions to independent mode" do
    user = create :user
    track = create :track
    completed_solution = create :solution, user: user, exercise: create(:exercise, track: track), independent_mode: false, completed_at: DateTime.now
    uncompleted_solution = create :solution, user: user, exercise: create(:exercise, track: track), independent_mode: false, completed_at: nil
    user_track = create :user_track, user: user, track: track

    SwitchTrackToIndependentMode.(user, track)

    [user_track, completed_solution, uncompleted_solution].each(&:reload)

    assert user_track.independent_mode?
    refute completed_solution.independent_mode
    assert uncompleted_solution.independent_mode
  end
end
