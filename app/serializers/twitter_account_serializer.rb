class TwitterAccountSerializer
  def serialize(account)
    {
      "slug" => account.slug.to_s,
      "consumer_key" => account.consumer_key,
      "consumer_secret" => account.consumer_secret,
      "access_token" => account.access_token,
      "access_token_secret" => account.access_token_secret
    }
  end

  def deserialize(hash)
    TwitterAccount.new(
      slug: hash["slug"].to_sym,
      consumer_key: hash["consumer_key"],
      consumer_secret: hash["consumer_secret"],
      access_token: hash["access_token"],
      access_token_secret: hash["access_token_secret"]
    )
  end
end
