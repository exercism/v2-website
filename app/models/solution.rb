class Solution < ApplicationRecord
  include SolutionBase

  belongs_to :approved_by, class_name: "User", optional: true

  has_many :iterations, dependent: :destroy, as: :solution
  has_many :discussion_posts, through: :iterations

  has_many :mentorships, class_name: "SolutionMentorship", dependent: :destroy
  has_many :ignored_mentorships, class_name: "IgnoredSolutionMentorship", dependent: :destroy
  has_many :solution_locks, dependent: :destroy
  has_many :mentors, through: :mentorships, source: :user

  has_many :stars, class_name: "SolutionStar", dependent: :destroy
  has_many :comments, class_name: "SolutionComment", dependent: :destroy

  delegate :auto_approve?, to: :exercise

  scope :core, -> { joins(:exercise).merge(Exercise.core) }
  scope :side, -> { joins(:exercise).merge(Exercise.side) }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :not_completed, -> { where(completed_at: nil) }

  scope :published, -> { where.not(published_at: nil) }
  scope :on_profile, -> { where(show_on_profile: true) }

  scope :legacy, -> { where("solutions.created_at < ?", Exercism::V2_MIGRATED_AT) }
  scope :not_legacy, -> { where("solutions.created_at >= ?", Exercism::V2_MIGRATED_AT) }

  scope :started, -> {
    where("EXISTS(SELECT TRUE FROM iterations WHERE iterations.solution_id = solutions.id)
           OR
           downloaded_at IS NOT NULL")
  }

  scope :not_started, -> {
    where("NOT EXISTS(SELECT TRUE FROM iterations WHERE iterations.solution_id = solutions.id)").
    where(downloaded_at: nil)
  }

  scope :submitted, -> {
    where("EXISTS(SELECT TRUE FROM iterations WHERE iterations.solution_id = solutions.id)")
  }

  scope :has_a_mentor, -> {
     where("EXISTS(SELECT TRUE FROM solution_mentorships WHERE solution_mentorships.solution_id = solutions.id)")
  }

  def display_published_at
    published_at == Exercism::V2_MIGRATED_AT ? created_at : published_at
  end

  def track_in_mentored_mode?
    track_in_independent_mode === false
  end

  def mentor_download_command
    "exercism download --uuid=#{uuid}"
  end

  def team_solution?
    false
  end

  def legacy?
    created_at < Exercism::V2_MIGRATED_AT
  end

  def approved?
    !!approved_by
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

  def mentoring_requested?
    !!mentoring_requested_at
  end

  def active_mentors
    mentors.where("solution_mentorships.user_id": TrackMentorship.select(:user_id))
  end

  def mentor_discussion_posts
    discussion_posts.where.not(user_id: user_id)
  end

  def user_track
    UserTrack.find_by(user_id: user_id, track_id: exercise.track_id)
  end
end
