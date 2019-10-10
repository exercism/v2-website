require "test_helper"

class ChangelogEntryTweetTest < ActiveSupport::TestCase
  test "#text returns copy with link" do
    tweet = build(:changelog_entry_tweet, copy: "Hello, world!")
    tweet.link = "exercism.io"

    assert_equal "Hello, world! exercism.io", tweet.text
  end

  test "invalid if copy is nil" do
    refute build(:changelog_entry_tweet, copy: nil).valid?
  end

  test "invalid if length goes over limit" do
    ChangelogEntryTweet.stubs(:character_limit).returns(1)

    refute build(:changelog_entry_tweet, copy: "He").valid?
  end

  test "valid if URL is shortened" do
    ChangelogEntryTweet.stubs(:character_limit).returns(6)
    ChangelogEntryTweet.stubs(:shortened_url_length).returns(1)

    tweet = build(:changelog_entry_tweet, copy: "Hello")
    tweet.link = "https://exercism.io/very-very-very-long-url"
    assert tweet.valid?
  end

  test "#tweet_to marks tweet as queued" do
    tweet = create(:changelog_entry_tweet)
    account = TwitterAccount.find(:main)

    tweet.tweet_to(account)

    assert tweet.queued?
  end
end
