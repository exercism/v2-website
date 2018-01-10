class Solution < ApplicationRecord
  include SolutionBase

  belongs_to :approved_by, class_name: "User", optional: true

  has_many :iterations
  has_many :discussion_posts, through: :iterations

  has_many :mentorships, class_name: "SolutionMentorship"
  has_many :mentors, through: :mentorships, source: :user

  has_many :reactions

  delegate :auto_approve?, to: :exercise

  def self.completed
    where.not(completed_at: nil)
  end

  def self.not_completed
    where(completed_at: nil)
  end

  def self.published
    where.not(published_at: nil)
  end

  def team_solution?
    false
  end

  def enable_mentoring!
    user_track = user.user_track_for(exercise.track)
    return if user_track.mentoring_allowance_used_up?
    update(mentoring_enabled: true)
  end

  def approved?
    !!approved_by
  end

  def downloaded?
    !!downloaded_at
  end

  def in_progress?
    downloaded? || iterations.size > 0
  end

  def published?
    !!published_at
  end

  def completed?
    !!completed_at
  end
end
