require "test_helper"

module ChangelogAdmin
  class ActionsTest < ActionView::TestCase
    test "show publish button if entry is unpublished" do
      entry = create(:changelog_entry, published_at: nil)

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", exact_text: "Publish"
    end

    test "hide publish button if entry is published" do
      entry = create(:changelog_entry, published_at: Time.new(2016, 12, 25))

      render "changelog_admin/entries/actions", entry: entry

      assert_select "a", 0, exact_text: "Publish"
    end
  end
end
