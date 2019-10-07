require "application_system_test_case"

module ChangelogAdmin
  class DeleteChangelogEntryTest < ApplicationSystemTestCase
    test "admin deletes a changelog entry" do
      Flipper.enable(:changelog)
      admin = create(:user, :onboarded, admin: true)
      entry = create(:changelog_entry)

      sign_in!(admin)
      visit changelog_admin_entry_path(entry)
      accept_alert { click_on "Delete" }

      assert_text "Entries"

      Flipper.disable(:changelog)
    end
  end
end
