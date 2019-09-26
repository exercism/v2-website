class ChangelogEntry < ApplicationRecord
  class EntryAlreadyPublishedError < StandardError; end;

  belongs_to :referenceable, polymorphic: true, optional: true
  belongs_to :created_by, class_name: "User"

  delegate :title, to: :referenceable, prefix: true, allow_nil: true
  delegate :name, to: :created_by, prefix: true

  def referenceable_gid
    referenceable.to_global_id
  end

  def referenceable
    ChangelogAdmin::Referenceable.for(super)
  end

  def publish!(time = Time.current)
    raise EntryAlreadyPublishedError if published?

    update!(published_at: time)
  end

  def published?
    published_at.present?
  end
end
