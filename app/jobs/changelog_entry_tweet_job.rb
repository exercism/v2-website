class ChangelogEntryTweetJob < ApplicationJob
  def perform(account, tweet)
    account = TwitterAccountSerializer.new.deserialize(account)

    ChangelogEntryServices::Tweet.(account, tweet)
  end
end
