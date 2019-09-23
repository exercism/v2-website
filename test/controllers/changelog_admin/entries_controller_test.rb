require "test_helper"
require_relative "./authorization_test_helpers"

module ChangelogAdmin
  class EntriesControllerTest < ActionDispatch::IntegrationTest
    extend AuthorizationTestHelpers

    test_requires_changelog_authorization("new") {
      get new_changelog_admin_entry_path
    }

    test_requires_feature_toggle("new") {
      get new_changelog_admin_entry_path
    }

    test_requires_changelog_authorization("create") {
      post changelog_admin_entries_path,
        params: { changelog_entry_form: { title: "Entry" } }
    }

    test_requires_feature_toggle("create") {
      post changelog_admin_entries_path,
        params: { changelog_entry_form: { title: "Entry" } }
    }

    test_requires_changelog_authorization("show") {
      entry = create(:changelog_entry)
      get changelog_admin_entry_path(entry)
    }

    test_requires_feature_toggle("show") {
      entry = create(:changelog_entry)
      get changelog_admin_entry_path(entry)
    }
  end
end
