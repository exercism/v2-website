class ChangelogEntryTweet < ApplicationRecord
  CHARACTER_LIMIT = 280
  SHORTENED_URL_LENGTH = 23

  enum status: { queued: 0, published: 1, failed: 2 }

  attr_writer :link

  def self.character_limit
    CHARACTER_LIMIT
  end

  def self.shortened_url_length
    SHORTENED_URL_LENGTH
  end

  belongs_to :entry, class_name: "ChangelogEntry", foreign_key: :changelog_entry_id

  validates :copy, presence: true
  validate :length_is_correct

  def text
    [copy, link].reject(&:empty?).join(" ")
  end

  def link
    @link ||= entry.tweet_link_url
  end

  def tweet_to(account)
    ChangelogEntryTweetJob.perform_later(
      TwitterAccountSerializer.new.serialize(account),
      self
    )
  end

  private

  def length_is_correct
    return if copy.blank?

    errors.add(:base, "Tweet is too long") if over_limit?
  end

  def over_limit?
    length > self.class.character_limit
  end

  def length
    link_length = [link.length, self.class.shortened_url_length].min
    copy_length = copy.length

    copy_length + link_length
  end
end
