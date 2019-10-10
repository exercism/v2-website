require "test_helper"
require "webmock/minitest"
require_relative "./authorization_test_helpers"

module ChangelogAdmin
  class EntriesControllerTest < ActionDispatch::IntegrationTest
    include ActiveJob::TestHelper
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

    test "raises an error when another user attempts to edit an entry" do
      Flipper.enable(:changelog)
      user = create(:user, :onboarded, may_edit_changelog: true)
      entry = create(:changelog_entry)
      AllowedToEditEntryPolicy.stubs(:allowed?).returns(false)

      sign_in!(user)
      get edit_changelog_admin_entry_path(entry)

      assert_response :unauthorized

      Flipper.disable(:changelog)
    end

    test "raises an error when another user attempts to update an entry" do
      Flipper.enable(:changelog)
      user = create(:user, :onboarded, may_edit_changelog: true)
      AllowedToEditEntryPolicy.stubs(:allowed?).returns(false)
      entry = create(:changelog_entry)

      sign_in!(user)
      patch changelog_admin_entry_path(entry)

      assert_response :unauthorized

      Flipper.disable(:changelog)
    end

    test "raises an error when an unauthorized user unpublishes an entry" do
      Flipper.enable(:changelog)
      user = create(:user, :onboarded, may_edit_changelog: true)
      AllowedToUnpublishEntryPolicy.stubs(:allowed?).returns(false)
      entry = create(:changelog_entry, published_at: Time.utc(2016, 12, 25))

      sign_in!(user)
      post unpublish_changelog_admin_entry_path(entry)

      assert_response :unauthorized

      Flipper.disable(:changelog)
    end

    test "entry is tweeted after it is published" do
      Flipper.enable(:changelog)
      admin = create(:user, :onboarded, admin: true)
      entry = create(:changelog_entry)
      create(:changelog_entry_tweet, copy: "Hello, world!", entry: entry)
      tweet_request = stub_request(
        :post,
        "https://api.twitter.com/1.1/statuses/update.json"
      ).
      with(body: { status: "Hello, world!" }).
      to_return(
        status: 200,
        body: { id: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

      perform_enqueued_jobs do
        sign_in!(admin)
        post publish_changelog_admin_entry_path(entry)
      end

      assert_requested(tweet_request)
      Flipper.disable(:changelog)
    end
  end
end
