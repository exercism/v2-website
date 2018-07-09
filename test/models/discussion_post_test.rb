require_relative '../test_helper'

class DiscussionPostTest < ActiveSupport::TestCase
  test "returns anonymous handle when user is nil" do
    post = build(:discussion_post, user: nil)

    assert_equal "Anonymous User", post.handle
  end

  test "returns default image when user is nil" do
    post = build(:discussion_post, user: nil)

    assert_equal "anonymous.png", post.avatar_url
  end
end
