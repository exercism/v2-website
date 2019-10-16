require "application_system_test_case"

module ChangelogAdmin
  class PublishChangelogEntryTest < ApplicationSystemTestCase
    include ActiveJob::TestHelper

    test "admin publishes a changelog entry" do
      perform_enqueued_jobs do
        travel_to(Time.utc(2016, 12, 25))
        Flipper.enable(:changelog)
        stub_request(
          :post,
          "https://api.twitter.com/1.1/statuses/update.json"
        ).
        with(body: { status: "Hello, world!" }).
        to_return(
          status: 200,
          body: { id: 1 }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        admin = create(:user, :onboarded, admin: true)
        entry = create(:changelog_entry)
        create(:changelog_entry_tweet, copy: "Hello, world!", entry: entry)

        sign_in!(admin)
        visit changelog_admin_entry_path(entry)
        accept_alert { click_on "Publish" }

        assert_text "Published at:\n2016-12-25 00:00:00 UTC"
        assert_text "Tweet published"

        Flipper.disable(:changelog)
        travel_back
      end
    end
  end
end
