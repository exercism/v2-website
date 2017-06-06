require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "unlocking track" do
    user = create :user
    track = create :track
    refute user.unlocked_track?(track)

    create :user_track, user: user, track: track
    assert user.unlocked_track?(track)
  end
end
