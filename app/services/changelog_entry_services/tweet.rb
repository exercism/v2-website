module ChangelogEntryServices
  class Tweet
    include Mandate

    initialize_with :account, :tweet

    def call
      begin
        account.tweet(tweet)
      rescue TwitterAccount::TweetFailed
        tweet.failed!
        raise
      end

      tweet.published!
    end
  end
end
