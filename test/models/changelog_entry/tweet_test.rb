require "test_helper"

class ChangelogEntry::TweetTest < ActiveSupport::TestCase
  test "#text returns copy with link" do
    tweet = ChangelogEntry::Tweet.new(
      copy: "Hello, world!",
      link: "exercism.io"
    )

    assert_equal "Hello, world! exercism.io", tweet.text
  end

  test "invalid if copy is nil" do
    refute ChangelogEntry::Tweet.new(copy: nil).valid?
  end

  test "invalid if length goes over limit" do
    ChangelogEntry::Tweet.stubs(:character_limit).returns(1)

    refute ChangelogEntry::Tweet.new(copy: "He").valid?
  end

  test "valid if URL is shortened" do
    ChangelogEntry::Tweet.stubs(:character_limit).returns(6)
    ChangelogEntry::Tweet.stubs(:shortened_url_length).returns(1)

    tweet = ChangelogEntry::Tweet.new(
      copy: "Hello",
      link: "https://exercism.io/very-very-very-long-url"
    )
    assert tweet.valid?
  end
end
