class ChangelogEntry::Tweet
  include ActiveModel::Validations
  CHARACTER_LIMIT = 280
  SHORTENED_URL_LENGTH = 23

  def self.character_limit
    CHARACTER_LIMIT
  end

  def self.shortened_url_length
    SHORTENED_URL_LENGTH
  end

  validates :copy, presence: true
  validate :length_is_correct

  def initialize(entry)
    @entry = entry
  end

  def text
    [copy, link].reject(&:empty?).join(" ")
  end

  private
  attr_reader :entry

  def copy
    entry.tweet_copy || ""
  end

  def link
    case
    when entry.details_html?
      Rails.application.routes.url_helpers.url_for(entry)
    when entry.info_url?
      entry.info_url
    else
      ""
    end
  end

  def length_is_correct
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
