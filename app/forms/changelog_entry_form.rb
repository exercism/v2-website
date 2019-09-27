class ChangelogEntryForm
  class CantChangeCreatedByError < StandardError
    def initialize(msg = "Created by isn't allowed to be changed")
      super
    end
  end

  def self.from_entry(entry)
    referenceable_gid = if entry.referenceable
                          GlobalID.create(entry.referenceable)
                        end

    new(
      id: entry.id,
      title: entry.title,
      details_markdown: entry.details_markdown,
      referenceable_gid: referenceable_gid,
      info_url: entry.info_url,
      created_by: entry.created_by
    )
  end

  include ActiveModel::Model

  validates :title, presence: true
  validates :created_by, presence: true

  attr_accessor(
    :id,
    :title,
    :details_markdown,
    :referenceable_gid,
    :info_url,
    :created_by,
  )

  def save
    if entry.persisted? && entry.created_by != created_by
      raise CantChangeCreatedByError
    end

    entry.assign_attributes(
      title: title,
      details_markdown: details_markdown,
      details_html: details_html,
      referenceable: referenceable,
      info_url: info_url,
      created_by: created_by
    )

    entry.save
  end

  def referenceable_types
    [Track, Exercise.includes(:track)].
      map { |type| ChangelogAdmin::ReferenceableType.new(type) }
  end

  def referenceable
    GlobalID::Locator.locate(referenceable_gid)
  end

  def entry
    @entry ||= id ? ChangelogEntry.find(id) : ChangelogEntry.new
  end

  private

  def details_html
    ParseMarkdown.(details_markdown)
  end
end
