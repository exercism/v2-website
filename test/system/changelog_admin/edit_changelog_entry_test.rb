require "application_system_test_case"

module ChangelogAdmin
  class EditChangelogEntryTest < ApplicationSystemTestCase
    test "admin edits a changelog entry" do
      Flipper.enable(:changelog)
      admin = create(:user, :onboarded, may_edit_changelog: true)
      entry = create(:changelog_entry,
                     title: "New Exercise",
                     details_markdown: "# We've added a new exercise!",
                     info_url: "https://github.com/exercism",
                     created_by: admin)
      track = create(:track, title: "Ruby")
      create(:exercise, track: track, title: "Hello world")

      sign_in!(admin)
      visit edit_changelog_admin_entry_path(entry)

      fill_in "Title", with: "New Exercise - Hello world"
      fill_in "Details", with: "# We've added a new exercise named Hello world!"
      select_option "Ruby - Hello world",
        selector: "#changelog_entry_form_referenceable_gid"
      fill_in "Info url", with: "https://github.com/exercism/hello-world"
      click_on "Save"

      assert_text "New Exercise - Hello world"
      assert_text "# We've added a new exercise named Hello world!"
      assert_text "Ruby - Hello world"
      assert_text "https://github.com/exercism/hello-world"

      Flipper.disable(:changelog)
    end

    test "site admin edits a changelog entry in behalf of another user" do
      Flipper.enable(:changelog)
      site_admin = create(:user, :onboarded, admin: true)
      entry = create(:changelog_entry,
                     title: "New Exercise",
                     details_markdown: "# We've added a new exercise!",
                     info_url: "https://github.com/exercism")
      track = create(:track, title: "Ruby")
      create(:exercise, track: track, title: "Hello world")

      sign_in!(site_admin)
      visit edit_changelog_admin_entry_path(entry)

      fill_in "Title", with: "New Exercise - Hello world"
      fill_in "Details", with: "# We've added a new exercise named Hello world!"
      select_option "Ruby - Hello world",
        selector: "#changelog_entry_form_referenceable_gid"
      fill_in "Info url", with: "https://github.com/exercism/hello-world"
      click_on "Save"

      assert_text "New Exercise - Hello world"
      assert_text "# We've added a new exercise named Hello world!"
      assert_text "Ruby - Hello world"
      assert_text "https://github.com/exercism/hello-world"

      Flipper.disable(:changelog)
    end
  end
end
