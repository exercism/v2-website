require "test_helper"

class ChangelogEntry::TweetTest < ActiveSupport::TestCase
  test "#text returns only copy if details are nil" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: nil)

    assert_equal "Hello, world!", ChangelogEntry::Tweet.new(entry).text
  end

  test "#text returns copy with link if details are present" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: "<p>New exercise!</p>")

    assert_equal(
      "Hello, world! https://test.exercism.io/changelog_entries/#{entry.id}",
      ChangelogEntry::Tweet.new(entry).text
    )
  end

  test "#text returns copy with link if info URL is present and details are blank" do
    entry = create(:changelog_entry,
                   tweet_copy: "Hello, world!",
                   details_html: nil,
                   info_url: "https://exercism.io")

    assert_equal(
      "Hello, world! https://exercism.io",
      ChangelogEntry::Tweet.new(entry).text
    )
  end

  test "invalid if copy is nil" do
    entry = create(:changelog_entry, tweet_copy: nil)

    refute ChangelogEntry::Tweet.new(entry).valid?
  end

  test "invalid if length goes over limit" do
    ChangelogEntry::Tweet.stubs(:character_limit).returns(1)

    entry = create(:changelog_entry, tweet_copy: "He")

    refute ChangelogEntry::Tweet.new(entry).valid?
  end

  test "valid if URL is shortened" do
    ChangelogEntry::Tweet.stubs(:character_limit).returns(6)
    ChangelogEntry::Tweet.stubs(:shortened_url_length).returns(1)

    entry = create(:changelog_entry,
                   tweet_copy: "Hello",
                   info_url: "https://exercism.io/very-very-very-long-url")

    assert ChangelogEntry::Tweet.new(entry).valid?
  end
end
