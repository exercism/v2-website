require "test_helper"

class ChangelogEntryTweetFormatterTest < ActiveSupport::TestCase
  test "returns empty string if tweet_copy is empty" do
    entry = create(:changelog_entry, tweet_copy: nil)

    assert_equal "", ChangelogEntryTweetFormatter.format(entry)
  end

  test "returns only tweet_copy if details are nil" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: nil)

    assert_equal "Hello, world!", ChangelogEntryTweetFormatter.format(entry)
  end

  test "returns tweet_copy with link if details are present" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: "<p>New exercise!</p>")

    assert_equal(
      "Hello, world! https://test.exercism.io/changelog_entries/#{entry.id}",
      ChangelogEntryTweetFormatter.format(entry)
    )
  end

  test "returns tweet_copy with link if info URL is present and details are blank" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: nil,
                   info_url: "https://exercism.io")

    assert_equal(
      "Hello, world! https://exercism.io",
      ChangelogEntryTweetFormatter.format(entry)
    )
  end
end
