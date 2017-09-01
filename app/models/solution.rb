class Solution < ApplicationRecord

  belongs_to :user
  belongs_to :exercise
  belongs_to :approved_by, class_name: "User", optional: true

  has_many :iterations
  has_many :discussion_posts, through: :iterations

  has_many :mentorships, class_name: "SolutionMentorship"
  has_many :mentors, through: :mentorships, source: :user

  has_many :reactions

  def self.completed
    where.not(completed_at: nil)
  end

  def self.not_completed
    where(completed_at: nil)
  end

  def self.published
    where.not(published_at: nil)
  end

  before_create do
    # Search engines derive meaning by using hyphens
    # as word-boundaries in URLs. Since we use the
    # solution UUID for URLs, we're removing the hyphen
    # to remove any spurious, accidental, and arbitrary
    # meaning.
    self.uuid = SecureRandom.uuid.gsub('-', '')
  end

  def to_param
    uuid
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

  def instructions
    git_exercise.instructions
  rescue
    ""
  end

  def test_suite
    git_exercise.test_suite
  rescue
    []
  end

  def git_exercise
    @git_exercise ||= Git::Exercise.new(exercise, git_slug, git_sha)
  end
end
