class TwitterAccount
  attr_reader(
    :consumer_key,
    :consumer_secret,
    :access_token,
    :access_token_secret
  )

  def self.config
    Rails.application.config_for("twitter_accounts")
  end

  def self.find(slug)
    new(config[slug])
  end

  def initialize(
    consumer_key:,
    consumer_secret:,
    access_token:,
    access_token_secret:
  )
    @consumer_key = consumer_key
    @consumer_secret = consumer_secret
    @access_token = access_token
    @access_token_secret = access_token_secret
  end

  def tweet(copy)
    TweetJob.perform_later(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      access_token: access_token,
      access_token_secret: access_token_secret,
      copy: copy
    )
  end

  def ==(other)
    consumer_key == other.consumer_key &&
      consumer_secret == other.consumer_secret &&
      access_token == other.access_token &&
      access_token_secret == other.access_token_secret
  end
end
