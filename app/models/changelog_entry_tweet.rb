class ChangelogEntryTweet
  include ActiveModel::Validations

  validates :copy, presence: true

  def initialize(entry)
    @entry = entry
  end

  def text
    [copy, link].compact.join(" ")
  end

  private
  attr_reader :entry

  def copy
    entry.tweet_copy
  end

  def link
    case
    when entry.details_html?
      Rails.application.routes.url_helpers.url_for(entry)
    when entry.info_url?
      entry.info_url
    end
  end
end
