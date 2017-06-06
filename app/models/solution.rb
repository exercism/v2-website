class Solution < ApplicationRecord
  belongs_to :user
  belongs_to :implementation
  has_one :exercise, through: :implementation

  def exercise_id
    implementation.exercise_id
  end
end
