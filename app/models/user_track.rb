class UserTrack < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :handle, handle: true

  scope :archived, -> { where.not(archived_at: nil) }
  scope :unarchived, -> { where(archived_at: nil) }

  MAX_MENTORING_SLOTS = 1

  def originated_in_v1?
    created_at < Exercism::V2_MIGRATED_AT
  end

  def mentored_mode?
    !independent_mode?
  end

  def num_completed_core_exercies
    solutions.completed.
              where("exercises.core": true,
                    "exercises.track_id": track_id).
              count
  end

  def solutions
    user.solutions.joins(:exercise).
                   where("exercises.track_id": track_id)
  end

  def archived?
    archived_at.present?
  end

  def solutions_being_mentored
    solutions.where(approved_by_id: nil).
              where(independent_mode: false)
  end

  def num_solutions_being_mentored
    solutions_being_mentored.count
  end

  def mentoring_slots_remaining
    MAX_MENTORING_SLOTS - num_solutions_being_mentored
  end

  def mentoring_slots_remaining?
    mentoring_slots_remaining > 0
  end

  def mentoring_allowance_used_up?
    !mentoring_slots_remaining?
  end
end
