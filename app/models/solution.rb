class Solution < ApplicationRecord

  belongs_to :user
  belongs_to :exercise
  belongs_to :approved_by, class_name: "User", optional: true

  has_many :iterations
  has_many :discussion_posts, through: :iterations

  def self.completed
    where.not(completed_at: nil)
  end

  def self.published
    where.not(published_at: nil)
  end

  def approved?
    !!approved_by
  end

  def cloned?
    !!cloned_at
  end

  def published?
    !!published_at
  end

  def completed?
    !!completed_at
  end

  def mentors
    @mentors ||= User.where(id: discussion_posts.where.not(user_id: user.id).select(:user_id))
  end

  def instructions
    git_exercise.instructions
  end

  def test_suite
    git_exercise.test_suite
  end

  def git_exercise
    @git_exercise ||= GitExercise.new(exercise, git_sha)
  end
end
