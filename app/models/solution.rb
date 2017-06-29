class Solution < ApplicationRecord

  enum status: [:unlocked, :cloned, :iterating, :completed_approved, :completed_unapproved]

  belongs_to :user
  belongs_to :exercise
  belongs_to :approved_by, class_name: "User", optional: true

  has_many :iterations
  has_many :discussion_posts, through: :iterations

  def approved?
    !!approved_by
  end

  def mentors
    @mentors ||= User.where(id: discussion_posts.where.not(user_id: user.id).select(:user_id))
  end
end
