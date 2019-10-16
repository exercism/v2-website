require "test_helper"

class TwitterAccountTest < ActiveSupport::TestCase
  test ".find returns twitter account based on slug" do
    account = TwitterAccount.find(:ruby)

    expected_account = TwitterAccount.new(slug: :ruby)
    assert_equal expected_account, account
  end

  test "#tweet enqueues a tweet job" do
    client = mock()
    account = TwitterAccount.new(client: client)

    client.expects(:update).with("Hello, world!")

    tweet = stub(text: "Hello, world!", valid?: true)
    account.tweet(tweet)
  end

  test "#tweet does not enqueue a tweet job when invalid" do
    client = mock()
    account = TwitterAccount.new(client: client)

    client.expects(:update).never

    tweet = stub(valid?: false)
    account.tweet(tweet)
  end
end
