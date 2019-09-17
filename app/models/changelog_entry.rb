class ChangelogEntry < ApplicationRecord
  belongs_to :referenceable, polymorphic: true, optional: true
  belongs_to :created_by, class_name: "User"

  delegate :title, to: :referenceable, prefix: true, allow_nil: true

  def referenceable_gid
    referenceable.to_global_id
  end

  def referenceable
    ChangelogAdmin::Referenceable.for(super)
  end
end
