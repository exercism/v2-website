class Solution < ApplicationRecord

  enum status: [:unlocked, :cloned, :iterating, :completed_approved, :completed_unapproved]

  belongs_to :user
  belongs_to :exercise
  belongs_to :approved_by_mentor, class_name: "User", optional: true

  has_many :iterations
end
