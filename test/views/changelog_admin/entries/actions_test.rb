require "test_helper"

module ChangelogAdmin
  class ActionsTest < ActionView::TestCase
    test "show publish button if entry is publishable" do
      entry = create(:changelog_entry)
      view.stubs(:allowed_to_edit_changelog_entry?)
      view.
        stubs(:allowed_to_publish_changelog_entry?).
        with(entry).
        returns(true)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", text: "Publish", exact: true
    end

    test "hide publish button if entry is unpublishable" do
      entry = create(:changelog_entry)
      view.stubs(:allowed_to_edit_changelog_entry?)
      view.
        stubs(:allowed_to_publish_changelog_entry?).
        with(entry).
        returns(false)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", text: "Publish", exact: true, count: 0
    end

    test "show edit button if entry is editable by user" do
      entry = create(:changelog_entry)
      view.stubs(:allowed_to_publish_changelog_entry?)
      view.
        stubs(:allowed_to_edit_changelog_entry?).
        with(entry).
        returns(true)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", text: "Edit", exact: true
    end

    test "hide edit button if entry is not editable by user" do
      entry = create(:changelog_entry)
      view.stubs(:allowed_to_publish_changelog_entry?)
      view.
        stubs(:allowed_to_edit_changelog_entry?).
        with(entry).
        returns(false)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", count: 0, text: "Edit", exact: true
    end
  end
end
