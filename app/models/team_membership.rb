class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :user

  scope :pending, -> { where(pending: true) }
  scope :not_pending, -> { where(pending: false) }
end
