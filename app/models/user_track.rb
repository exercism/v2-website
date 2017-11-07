class UserTrack < ApplicationRecord

  belongs_to :user
  belongs_to :track

  validates :handle, handle: true

  def normal_mode?
    !independent_mode?
  end

  def num_completed_core_exercies
    solutions.completed.
              where("exercises.core": true,
                    "exercises.track_id": track_id).
              count
  end

  def mentoring_allowance_used_up?
    solutions.where("completed_at IS NOT NULL OR approved_by_id IS NOT NULL").
              where(mentoring_enabled: true).
              count >= 5
  end

  def solutions
    user.solutions.joins(:exercise).
                   where("exercises.track_id": track_id)
  end
end
