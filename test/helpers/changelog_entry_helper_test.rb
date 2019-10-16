require "test_helper"

class ChangelogEntryHelperTest < ActionView::TestCase
  test "#changelog_entry_info_url_text returns unique text depending on URL" do
    assert_equal(
      "View PR on GitHub",
      changelog_entry_info_url_text("https://github.com/exercism/website/pull/1")
    )
    assert_equal(
      "View commit on GitHub",
      changelog_entry_info_url_text("https://github.com/exercism/website/commit/1")
    )
    assert_equal(
      "View issue on GitHub",
      changelog_entry_info_url_text("https://github.com/exercism/exercism/issues/1")
    )
    assert_equal "View", changelog_entry_info_url_text("https://ANY_URL")
  end
end
