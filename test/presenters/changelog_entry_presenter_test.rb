require 'test_helper'

class ChangelogEntryPresenterTest < ActiveSupport::TestCase
  test "#tweet_status_text returns message about tweet status" do
    entry = stub(tweet_status: "queued")

    assert_equal(
      "Preparing to tweet...",
      ChangelogEntryPresenter.new(entry).tweet_status_text
    )

    entry = stub(tweet_status: "published")

    assert_equal(
      "Tweet published",
      ChangelogEntryPresenter.new(entry).tweet_status_text
    )

    entry = stub(tweet_status: "failed")

    assert_equal(
      "Tweet failed... Retrying",
      ChangelogEntryPresenter.new(entry).tweet_status_text
    )
  end
end

