class ChangelogEntry < ApplicationRecord
  class EntryAlreadyPublishedError < StandardError; end;

  belongs_to :referenceable, polymorphic: true, optional: true
  belongs_to :created_by, class_name: "User"

  delegate :title, to: :referenceable, prefix: true
  delegate :icon, to: :referenceable
  delegate :name, :handle, to: :created_by, prefix: true

  scope :published, -> { where.not(published_at: nil) }

  def referenceable_gid
    referenceable.to_global_id
  end

  def referenceable
    Referenceable.for(super)
  end

  def publish!(time = Time.current)
    raise EntryAlreadyPublishedError if published?

    update!(published_at: time)
  end

  def published?
    published_at.present?
  end

  def created_by?(user)
    created_by == user
  end
end
