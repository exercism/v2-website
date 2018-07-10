require "test_helper"

class NullUserTest < ActiveSupport::TestCase
  test "handle returns 'Anonymous User'" do
    assert_equal "Anonymous User", NullUser.new.handle
  end

  test "avatar_url returns default avatar" do
    assert_equal User::DEFAULT_AVATAR, NullUser.new.avatar_url
  end
end
