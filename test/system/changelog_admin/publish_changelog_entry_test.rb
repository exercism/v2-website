require "application_system_test_case"

module ChangelogAdmin
  class PublishChangelogEntryTest < ApplicationSystemTestCase
    test "admin publishes a changelog entry" do
      travel_to(Time.utc(2016, 12, 25))
      Flipper.enable(:changelog)
      admin = create(:user, :onboarded, admin: true)
      entry = create(:changelog_entry)

      sign_in!(admin)
      visit changelog_admin_entry_path(entry)
      accept_alert { click_on "Publish" }

      assert_text "Published at\n2016-12-25 00:00:00 UTC"

      Flipper.disable(:changelog)
      travel_back
    end
  end
end
