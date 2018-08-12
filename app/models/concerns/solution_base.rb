require 'active_support/concern'

module SolutionBase
  extend ActiveSupport::Concern

  def self.find_by_uuid!(uuid, user_id = nil)
    scope = Solution
    scope = scope.where(user_id: user_id) if user_id
    scope.find_by_uuid!(uuid)
  rescue ActiveRecord::RecordNotFound
    scope = TeamSolution
    scope = scope.where(user_id: user_id) if user_id
    scope.find_by_uuid!(uuid)
  end

  included do
    belongs_to :user
    belongs_to :exercise

    before_create do
      # Search engines derive meaning by using hyphens
      # as word-boundaries in URLs. Since we use the
      # solution UUID for URLs, we're removing the hyphen
      # to remove any spurious, accidental, and arbitrary
      # meaning.
      self.uuid = SecureRandom.uuid.gsub('-', '')
    end
  end

  def to_param
    uuid
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

  #class_methods do
  #  ...
  #end
end
