require 'test_helper'

class Git::NullGithubProfileTest < ActiveSupport::TestCase
  test "name returns nil" do
    assert_nil Git::NullGithubProfile.new.name
  end

  test "bio returns nil" do
    assert_nil Git::NullGithubProfile.new.bio
  end

  test "avatar_url returns nil" do
    assert_nil Git::NullGithubProfile.new.avatar_url
  end

  test "link_url returns nil" do
    assert_nil Git::NullGithubProfile.new.link_url
  end
end
