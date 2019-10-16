require "application_system_test_case"

module ChangelogAdmin
  class ViewAllChangelogEntriesTest < ApplicationSystemTestCase
    test "admin views all changelog entries" do
      Flipper.enable(:changelog)
      admin = create(:user,
                     :onboarded,
                     may_edit_changelog: true,
                     name: "Changelog Admin")
      entry = create(:changelog_entry, title: "First entry", created_by: admin)

      sign_in!(admin)
      visit changelog_admin_entries_path

      assert_text "First entry"
      assert_text "Changelog Admin"
      assert_text "No"
      assert_link "View", href: changelog_admin_entry_path(entry)
      assert_link "Add a new changelog entry", href: new_changelog_admin_entry_path

      Flipper.disable(:changelog)
    end
  end
end
