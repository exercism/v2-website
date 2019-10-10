require "test_helper"

module ChangelogEntryServices
  class TweetTest < ActiveSupport::TestCase
    test "marks tweet as failed before reraising error" do
      account = stub()
      tweet = create(:changelog_entry_tweet)
      account.stubs(:tweet).raises(TwitterAccount::TweetFailed)

      assert_raises TwitterAccount::TweetFailed do
        ChangelogEntryServices::Tweet.(account, tweet)
      end
      assert tweet.failed?
    end
  end
end
