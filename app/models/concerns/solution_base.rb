require 'active_support/concern'

module SolutionBase
  extend ActiveSupport::Concern

  def self.find_by_uuid!(uuid)
    Solution.find_by_uuid!(uuid)
  rescue ActiveRecord::RecordNotFound
    TeamSolution.find_by_uuid!(uuid)
  end

  included do
    belongs_to :user
    belongs_to :exercise

    delegate :track, to: :exercise
    delegate :head, to: :track, prefix: true

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

  def downloaded?
    !!downloaded_at
  end


  #class_methods do
  #  ...
  #end
end
