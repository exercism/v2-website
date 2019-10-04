require "test_helper"

class ChangelogEntryHelperTest < ActionView::TestCase
  test "#allowed_to_edit_changelog_entry? calls correct policy" do
    entry = create(:changelog_entry)
    user = create(:user)
    ChangelogAdmin::AllowedToEditEntryPolicy.
      stubs(:allowed?).
      with(entry: entry, user: user).
      returns(true)

    assert allowed_to_edit_changelog_entry?(entry, user: user)
  end

  test "#allowed_to_publish_changelog_entry? calls correct policy" do
    entry = create(:changelog_entry)
    user = create(:user)
    ChangelogAdmin::AllowedToPublishEntryPolicy.
      stubs(:allowed?).
      with(entry: entry, user: user).
      returns(true)

    assert allowed_to_publish_changelog_entry?(entry, user: user)
  end

  test "#allowed_to_unpublish_changelog_entry? calls correct policy" do
    entry = create(:changelog_entry)
    user = create(:user)
    ChangelogAdmin::AllowedToUnpublishEntryPolicy.
      stubs(:allowed?).
      with(entry: entry, user: user).
      returns(true)

    assert allowed_to_unpublish_changelog_entry?(entry, user: user)
  end

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
