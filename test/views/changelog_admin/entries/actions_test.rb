require "test_helper"

module ChangelogAdmin
  class ActionsTest < ActionView::TestCase
    test "show publish button if entry is unpublished" do
      user = create(:user)
      entry = create(:changelog_entry, published_at: nil)
      view.stubs(:current_user).returns(user)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", text: "Publish", exact: true
    end

    test "hide publish button if entry is published" do
      user = create(:user)
      entry = create(:changelog_entry, published_at: Time.new(2016, 12, 25))
      view.stubs(:current_user).returns(user)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", text: "Publish", exact: true, count: 0

    end

    test "show edit button if entry is editable by user" do
      user = create(:user)
      entry = create(:changelog_entry, created_by: user)
      view.stubs(:current_user).returns(user)
      view.
        stubs(:allowed_to_edit_changelog_entry?).
        with(entry).
        returns(true)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", text: "Edit", exact: true
    end

    test "hide edit button if entry is not editable by user" do
      user = create(:user)
      other_user = create(:user)
      entry = create(:changelog_entry, created_by: other_user)
      view.stubs(:current_user).returns(user)
      view.
        stubs(:allowed_to_edit_changelog_entry?).
        with(entry).
        returns(false)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", count: 0, text: "Edit", exact: true
    end
  end
end
