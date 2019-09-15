require 'test_helper'

class SwitchTrackToIndependentModeTest < ActiveSupport::TestCase
  test "sets uncompleted solutions to independent mode" do
    user = create :user
    track = create :track
    solution = create :solution, user: user, exercise: create(:exercise, track: track), completed_at: DateTime.now, track_in_independent_mode: false
    user_track = create :user_track, user: user, track: track

    SwitchTrackToIndependentMode.(user, track)

    [user_track, solution].each(&:reload)

    assert user_track.independent_mode?
    assert solution.track_in_independent_mode
  end
end
