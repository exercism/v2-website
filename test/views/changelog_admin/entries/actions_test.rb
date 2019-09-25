require "test_helper"

module ChangelogAdmin
  class ActionsTest < ActionView::TestCase
    test "show publish button if entry is unpublished" do
      entry = create(:changelog_entry, published_at: nil)
      controller.stubs(:current_user)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", exact_text: "Publish"
    end

    test "hide publish button if entry is published" do
      entry = create(:changelog_entry, published_at: Time.new(2016, 12, 25))
      controller.stubs(:current_user)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", 0, exact_text: "Publish"

    end

    test "show edit button if entry is editable by user" do
      user = create(:user)
      entry = create(:changelog_entry, created_by: user)
      controller.stubs(:current_user).returns(user)
      controller.
        stubs(:allowed_to_edit_changelog_entry?).
        with(entry).
        returns(true)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", text: "Edit"
    end

    test "hide edit button if entry is not editable by user" do
      user = create(:user)
      other_user = create(:user)
      entry = create(:changelog_entry, created_by: other_user)
      controller.stubs(:current_user).returns(user)
      controller.
        stubs(:allowed_to_edit_changelog_entry?).
        with(entry).
        returns(false)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", count: 0, text: "Edit"
    end
  end
end
