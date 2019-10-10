require "twitter"

class TwitterAccount
  include ActiveModel::AttributeAssignment

  def self.config
    Rails.application.config_for("twitter_accounts")
  end

  def self.find(slug)
    attrs = config.find { |account| account[:slug] == slug }
    new(attrs)
  end

  attr_accessor(
    :slug,
    :consumer_key,
    :consumer_secret,
    :access_token,
    :access_token_secret,
    :client,
  )

  def initialize(attrs)
    assign_attributes(attrs)
  end

  def tweet(tweet)
    return unless tweet.valid?

    client.update(tweet.text)
  end

  def ==(other)
    slug == other.slug
  end

  def client
    @client ||= Twitter::REST::Client.new(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      access_token: access_token,
      access_token_secret: access_token_secret
    )
  end
end
