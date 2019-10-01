require "twitter"

class TweetJob < ApplicationJob
  def perform(
    consumer_key:,
    consumer_secret:,
    access_token:,
    access_token_secret:,
    copy:
  )
    client = Twitter::REST::Client.new(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      access_token: access_token,
      access_token_secret: access_token_secret
    )

    client.update(copy)
  end
end
