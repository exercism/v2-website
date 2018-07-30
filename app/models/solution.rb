class Solution < ApplicationRecord
  include SolutionBase

  belongs_to :approved_by, class_name: "User", optional: true

  has_many :iterations, dependent: :destroy
  has_many :discussion_posts, through: :iterations

  has_many :mentorships, class_name: "SolutionMentorship"
  has_many :mentors, through: :mentorships, source: :user

  has_many :reactions

  delegate :auto_approve?, :track, to: :exercise

  def self.completed
    where.not(completed_at: nil)
  end

  def self.not_completed
    where(completed_at: nil)
  end

  def self.published
    where.not(published_at: nil)
  end

  def self.started
    where("EXISTS(SELECT NULL FROM iterations WHERE iterations.solution_id = solutions.id)
           OR
           downloaded_at IS NOT NULL")
  end

  def self.not_started
    where("NOT EXISTS(SELECT NULL FROM iterations WHERE iterations.solution_id = solutions.id)").
    where(downloaded_at: nil)
  end

  def mentored_mode?
    !independent_mode?
  end

  def mentor_download_command
    "exercism download --uuid=#{uuid}"
  end

  def team_solution?
    false
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

  def active_mentors
    mentors.where("solution_mentorships.user_id": TrackMentorship.select(:user_id))
  end

  def user_track
    UserTrack.find_by(user_id: user_id, track_id: exercise.track_id)
  end
end
