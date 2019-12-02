class Research::ExperimentSolution < ApplicationRecord
  include SolutionBase

  belongs_to :user
  belongs_to :exercise
  belongs_to :experiment

  has_many :submissions, as: :solution

  scope :by_part, -> (language:, part:) {
    slugs = exercises.map do
      Research::SolutionSlug.construct(
        language: language,
        part: part,
        exercise: exercise
      )
    end

    where("exercises.slug": slugs)
  }

  def self.exercises
    ["a", "b"]
  end

  def research_experiment_solution?
    true
  end

  def language
    Research::SolutionSlug.deconstruct(exercise.slug)[:language]
  end
end
