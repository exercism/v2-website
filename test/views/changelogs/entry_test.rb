require "test_helper"

module Changelogs
  class EntryTest < ActionView::TestCase
    test "does not render link when no info url is given" do
      entry = build(:changelog_entry, info_url: nil)

      render "changelogs/entry", entry: entry

      assert_select "a", text: "View", count: 0, exact: true
    end
  end
end
