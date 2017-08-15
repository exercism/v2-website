require 'test_helper'

class BootstrapsUserTest < ActiveSupport::TestCase
  test "creates auth token" do
    user = create :user
    BootstrapsUser.bootstrap(user)

    assert_equal 1, AuthToken.where(user_id: user.id).count
  end

  test "joins track" do
    user = create :user
    track = create :track

    JoinsTrack.expects(:join!).with(user, track)
    BootstrapsUser.bootstrap(user, track.id)
  end
end


