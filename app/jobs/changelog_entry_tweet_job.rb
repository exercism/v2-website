class ChangelogEntryTweetJob < ApplicationJob
  def perform(account, tweet)
    account = TwitterAccountSerializer.new.deserialize(account)

    account.tweet(tweet)

    tweet.published!
  end
end
