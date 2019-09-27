require "test_helper"

class ChangelogEntryHelperTest < ActionView::TestCase
  test "#allowed_to_edit_changelog_entry? calls correcct policy" do
    entry = create(:changelog_entry)
    user = create(:user)
    ChangelogAdmin::AllowedToEditEntryPolicy.
      stubs(:allowed?).
      with(entry: entry, user: user).
      returns(true)

    assert allowed_to_edit_changelog_entry?(entry, user: user)
  end

  test "#allowed_to_publish_changelog_entry? calls correcct policy" do
    entry = create(:changelog_entry)
    user = create(:user)
    ChangelogAdmin::AllowedToPublishEntryPolicy.
      stubs(:allowed?).
      with(entry: entry, user: user).
      returns(true)

    assert allowed_to_publish_changelog_entry?(entry, user: user)
  end
end
