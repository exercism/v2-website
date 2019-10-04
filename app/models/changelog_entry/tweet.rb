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

  def self.from_entry(entry)
    new(copy: entry.tweet_copy, link: entry.tweet_link)
  end

  validates :copy, presence: true
  validate :length_is_correct

  def initialize(copy:, link: nil)
    @copy = copy || ""
    @link = link || ""
  end

  def text
    [copy, link].reject(&:empty?).join(" ")
  end

  private
  attr_reader :copy, :link

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
