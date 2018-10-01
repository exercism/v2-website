class UserTrack < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :handle, handle: true

  scope :archived, -> { where.not(archived_at: nil) }
  scope :unarchived, -> { where(archived_at: nil) }

  MAX_INDEPENDENT_MODE_MENTORING_SLOTS = 1
  MAX_MENTORED_MODE_MENTORING_SLOTS = 3

  def originated_in_v1?
    created_at < Exercism::V2_MIGRATED_AT
  end

  def mentored_mode?
    !independent_mode?
  end

  def num_completed_core_exercises
    completed_core_exercise_ids.count
  end

  def num_completed_side_exercises
    completed_side_exercise_ids.count
  end

  def num_avaliable_exercises
    if mentored_mode?
      num_avaliable_core_exercises + num_avaliable_side_exercises
    else
      solutions.not_completed.count
    end
  end

  def num_avaliable_core_exercises
    if mentored_mode?
      solutions.not_completed.
                where("exercises.core": true).
                count
    else
      track.exercises.core.
                      active.
                      where.not(id: completed_core_exercise_ids).
                      count
    end
  end

  def num_avaliable_side_exercises
    if mentored_mode?
      solutions.not_completed.
                where.not("exercises.unlocked_by": nil).
                where("exercises.core": false).
                count
      +
      track.exercises.side.
                where(unlocked_by: nil).
                where.not(id: completed_side_exercise_ids).
                count
    else
      track.exercises.side.
                      active.
                      where.not(id: completed_side_exercise_ids).
                      count
    end
  end

  def solutions
    user.solutions.joins(:exercise).
                   where("exercises.track_id": track_id)
  end

  def archived?
    archived_at.present?
  end

  def solutions_using_mentoring_allowance
    s = solutions.started.
                  where(approved_by_id: nil).
                  where.not(mentoring_requested_at: nil)
    s = s.side if mentored_mode?
    s
  end

  def max_mentoring_slots
    independent_mode?? MAX_INDEPENDENT_MODE_MENTORING_SLOTS :
                       MAX_MENTORED_MODE_MENTORING_SLOTS
  end

  def mentoring_slots_remaining
    max_mentoring_slots - solutions_using_mentoring_allowance.count
  end

  def mentoring_slots_remaining?
    mentoring_slots_remaining > 0
  end

  def mentoring_allowance_used_up?
    !mentoring_slots_remaining?
  end

  private

  def completed_core_exercise_ids
    solutions.completed.
              where("exercises.core": true).
              select(:exercise_id)
  end

  def completed_side_exercise_ids
    solutions.completed.
              where("exercises.core": false).
              select(:exercise_id)
  end
end
