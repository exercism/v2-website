class Solution < ApplicationRecord

  enum status: [:unlocked, :cloned, :iterating, :mentor_approved, :user_completed, :mentor_completed]

  belongs_to :user
  belongs_to :exercise

  has_many :iterations
end
