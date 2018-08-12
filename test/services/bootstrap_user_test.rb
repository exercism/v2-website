require 'test_helper'

class BootstrapUserTest < ActiveSupport::TestCase
  test "creates auth token" do
    user = create :user
    BootstrapUser.(user)

    assert_equal 1, AuthToken.where(user_id: user.id).count
  end

  test "joins track" do
    user = create :user
    track = create :track

    JoinsTrack.expects(:join!).with(user, track)
    BootstrapUser.(user, track.id)
  end
end
