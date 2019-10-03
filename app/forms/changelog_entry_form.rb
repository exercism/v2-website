class ChangelogEntryForm
  def self.from_entry(entry)
    new(
      id: entry.id,
      title: entry.title,
      details_markdown: entry.details_markdown,
      referenceable_gid: entry.referenceable_gid,
      info_url: entry.info_url,
      created_by: entry.created_by
    )
  end

  include ActiveModel::Model

  validates :title, presence: true
  validates :created_by, presence: true
  validate :tweet_is_valid

  attr_accessor(
    :id,
    :title,
    :details_markdown,
    :referenceable_gid,
    :info_url,
    :created_by,
    :tweet_copy,
  )

  def save
    entry.save
  end

  def referenceable_types
    [Track, Exercise.includes(:track)].
      map { |type| ChangelogEntry::ReferenceableType.new(type) }
  end

  def referenceable
    GlobalID::Locator.locate(referenceable_gid)
  end

  def entry
    return @entry if @entry

    @entry = id ? ChangelogEntry.find(id) : ChangelogEntry.new
    @entry.tap do |entry|
      entry.assign_attributes(
        title: title,
        details_markdown: details_markdown,
        details_html: details_html,
        referenceable: referenceable,
        referenceable_key: referenceable_key,
        info_url: info_url,
        created_by: created_by,
        tweet_copy: tweet_copy
      )
    end
  end

  private

  def details_html
    ParseMarkdown.(details_markdown)
  end

  def referenceable_key
    return if referenceable.blank?

    "#{referenceable.class.name.underscore}_#{referenceable.id}"
  end

  def tweet_is_valid
    return if tweet_copy.blank?

    tweet = ChangelogEntryTweet.new(entry)

    errors.add(:tweet_copy, "is too long") unless tweet.valid?
  end
end
