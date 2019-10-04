require "test_helper"

class ChangelogEntry::FriendlyUrlTest < ActiveSupport::TestCase
  test "#url returns parametrized url" do
    entry = create(:changelog_entry, title: "Hello, world!")

    assert_equal(
      "https://test.exercism.io/changelog_entries/hello-world-#{entry.id}",
      ChangelogEntry::FriendlyUrl.new(entry).url
    )
  end
end
