# TODO - Validate handle is unique
#
class UserTrack < ApplicationRecord
  belongs_to :user
  belongs_to :track

  def num_completed_core_exercies
    user.solutions.joins(:exercise).
                   completed.
                   where("exercises.core": true,
                         "exercises.track_id": track_id).
                   count
  end
end
