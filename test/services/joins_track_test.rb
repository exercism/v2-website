require 'test_helper'

class JoinsTrackTest < ActiveSupport::TestCase
  test "starts track" do
    user = create :user
    track = create :track
    user_track = JoinsTrack.start!(user, track)
    assert user_track.persisted?
    assert_equal user, user_track.user
    assert_equal track, user_track.track
  end

  test "does not duplicate track" do
    user = create :user
    track = create :track
    create :user_track, user: user, track: track

    refute JoinsTrack.start!(user, track)
    assert_equal 1, UserTrack.where(track: track, user: user).size
  end
end

