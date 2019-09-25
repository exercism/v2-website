require "test_helper"

class ChangelogEntryTest < ActiveSupport::TestCase
  test "#publish! sets the published_at time" do
    time = Time.utc(2016, 12, 25)
    entry = create(:changelog_entry)

    entry.publish!(time)

    assert_equal time, entry.published_at
  end

  test "#publish! raises an error when publishing an already published entry" do
    time = Time.utc(2016, 12, 25)
    entry = create(:changelog_entry, published_at: time)

    assert_raises ChangelogEntry::EntryAlreadyPublishedError do
      entry.publish!
    end
  end

  test "published? returns true if published_at is set" do
    entry = create(:changelog_entry, published_at: Time.new(2016, 12, 25))

    assert entry.published?
  end

  test "published? returns false if published_at isn't set" do
    entry = create(:changelog_entry, published_at: nil)

    refute entry.published?
  end
end
