require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "unlocking track" do
    user = create :user
    track = create :track
    refute user.joined_track?(track)

    create :user_track, user: user, track: track
    assert user.joined_track?(track)
  end

  test "mentor?" do
    user = create :user
    refute user.mentor?

    create :track_mentorship, user: user
    user.reload
    assert user.mentor?
  end
end
