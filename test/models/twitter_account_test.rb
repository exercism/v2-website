require "test_helper"

class TwitterAccountTest < ActiveSupport::TestCase
  test ".find returns twitter account based on slug" do
    account = TwitterAccount.find(:ruby)

    expected_account = TwitterAccount.new(slug: :ruby)
    assert_equal expected_account, account
  end

  test "#tweet enqueues a tweet job" do
    account = TwitterAccount.new(
      consumer_key: "KEY",
      consumer_secret: "SECRET",
      access_token: "TOKEN",
      access_token_secret: "TOKEN_SECRET"
    )

    TweetJob.
      expects(:perform_later).
      with(
        consumer_key: "KEY",
        consumer_secret: "SECRET",
        access_token: "TOKEN",
        access_token_secret: "TOKEN_SECRET",
        text: "Hello, world!"
      )

    tweet = mock(text: "Hello, world!", valid?: true)
    account.tweet(tweet)
  end

  test "#tweet does not enqueue a tweet job when invalid" do
    account = TwitterAccount.new(
      consumer_key: "KEY",
      consumer_secret: "SECRET",
      access_token: "TOKEN",
      access_token_secret: "TOKEN_SECRET"
    )

    TweetJob.expects(:perform_later).never

    tweet = mock(valid?: false)
    account.tweet(tweet)
  end
end
