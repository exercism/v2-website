class ChangelogEntryTweetFormatter
  def self.format(entry)
    new(entry).format
  end

  def initialize(entry)
    @entry = entry
  end

  def format
    [tweet_copy, tweet_link].compact.join(" ")
  end

  private
  attr_reader :entry

  def tweet_copy
    entry.tweet_copy
  end

  def tweet_link
    case
    when entry.details_html?
      Rails.application.routes.url_helpers.url_for(entry)
    when entry.info_url?
      entry.info_url
    end
  end
end
