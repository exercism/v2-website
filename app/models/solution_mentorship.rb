class SolutionMentorship < ApplicationRecord
  STATUSES = [
    { text: "Requires action from you", value: :require_action },
    { text: "Waiting for them", value: :awaiting_user },
    { text: "Completed", value: :completed },
    { text: "Stale", value: :stale },
    { text: "Unsubscribed", value: :unsubscribed },
    { text: "Legacy", value: :legacy },
  ]

  belongs_to :user
  belongs_to :solution

  scope :active, -> { where(abandoned: false) }
  scope :requires_action, -> { where.not(requires_action_since: nil) }

  def requires_action?
    !!requires_action_since
  end
end
