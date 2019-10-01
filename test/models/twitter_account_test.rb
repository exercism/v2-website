require "test_helper"

class TwitterAccountTest < ActiveSupport::TestCase
  test ".find returns twitter account based on slug" do
    account = TwitterAccount.find(:ruby)

    expected_account = TwitterAccount.new(
      consumer_key: "KEY",
      consumer_secret: "SECRET",
      access_token: "TOKEN",
      access_token_secret: "TOKEN_SECRET"
    )
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
        copy: "Hello, world!"
      )

    account.tweet("Hello, world!")
  end
end
