class Solution < ApplicationRecord

  enum status: [:unlocked, :started, :submitted, :mentor_approved, :user_completed, :mentor_completed]

  belongs_to :user
  belongs_to :implementation
  has_one :exercise, through: :implementation

  def exercise_id
    implementation.exercise_id
  end
end
