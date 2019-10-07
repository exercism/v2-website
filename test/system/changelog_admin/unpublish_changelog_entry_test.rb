require "application_system_test_case"

module ChangelogAdmin
  class UnpublishChangelogEntryTest < ApplicationSystemTestCase
    test "admin unpublishes a changelog entry" do
      Flipper.enable(:changelog)
      Flipper.enable(:changelog_destructive)
      admin = create(:user, :onboarded, admin: true)
      entry = create(:changelog_entry, published_at: Time.utc(2016, 12, 25))

      sign_in!(admin)
      visit changelog_admin_entry_path(entry)
      accept_alert { click_on "Unpublish" }

      assert_link "Publish"

      Flipper.disable(:changelog)
      Flipper.disable(:changelog_destructive)
    end
  end
end
