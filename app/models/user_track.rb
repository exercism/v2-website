class UserTrack < ApplicationRecord

  belongs_to :user
  belongs_to :track

  validates :handle, handle: true

  def num_completed_core_exercies
    user.solutions.joins(:exercise).
                   completed.
                   where("exercises.core": true,
                         "exercises.track_id": track_id).
                   count
  end

  def normal_mode?
    !independent_mode?
  end
end
