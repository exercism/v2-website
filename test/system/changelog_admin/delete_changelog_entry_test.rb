require "application_system_test_case"

module ChangelogAdmin
  class DeleteChangelogEntryTest < ApplicationSystemTestCase
    test "admin deletes a changelog entry" do
      Flipper.enable(:changelog)
      Flipper.enable(:changelog_destructive)
      admin = create(:user, :onboarded, admin: true)
      entry = create(:changelog_entry)

      sign_in!(admin)
      visit changelog_admin_entry_path(entry)
      accept_alert { click_on "Delete" }

      assert_text "Changelog - Admin"

      Flipper.disable(:changelog)
      Flipper.disable(:changelog_destructive)
    end
  end
end
