require "test_helper"

class ChangelogEntryTweetTest < ActiveSupport::TestCase
  test "#text returns empty string if copy is empty" do
    entry = create(:changelog_entry, tweet_copy: nil)

    assert_equal "", ChangelogEntryTweet.new(entry).text
  end

  test "#text returns only copy if details are nil" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: nil)

    assert_equal "Hello, world!", ChangelogEntryTweet.new(entry).text
  end

  test "#text returns copy with link if details are present" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: "<p>New exercise!</p>")

    assert_equal(
      "Hello, world! https://test.exercism.io/changelog_entries/#{entry.id}",
      ChangelogEntryTweet.new(entry).text
    )
  end

  test "#text returns copy with link if info URL is present and details are blank" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: nil,
                   info_url: "https://exercism.io")

    assert_equal(
      "Hello, world! https://exercism.io",
      ChangelogEntryTweet.new(entry).text
    )
  end

  test "invalid if copy is nil" do
    entry = create(:changelog_entry, tweet_copy: nil)

    refute ChangelogEntryTweet.new(entry).valid?
  end
end
