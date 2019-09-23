class ChangelogEntryForm
  class UnauthorizedUserError < StandardError
    def initialize(msg = "User isn't allowed to save an entry")
      super
    end
  end

  include ActiveModel::Model

  validates :title, presence: true

  attr_accessor(
    :title,
    :details_markdown,
    :referenceable_gid,
    :info_url,
    :created_by
  )

  attr_reader :entry

  def initialize(*args)
    super

    @entry = ChangelogEntry.new(
      title: title,
      details_markdown: details_markdown,
      referenceable: referenceable,
      info_url: info_url,
      created_by: created_by
    )
  end

  def save
    raise UnauthorizedUserError unless created_by.may_edit_changelog?

    entry.save
  end

  def referenceable_types
    [Track, Exercise.includes(:track)].
      map { |type| ChangelogAdmin::ReferenceableType.new(type) }
  end

  def referenceable
    GlobalID::Locator.locate(referenceable_gid)
  end
end
