class Research::ExperimentSolution < ApplicationRecord
  include SolutionBase

  SLUG_FORMAT = "%{language}-%{exercise}-%{part}"

  belongs_to :user
  belongs_to :exercise
  belongs_to :experiment

  has_many :submissions, as: :solution

  scope :by_part, -> (language:, part:) {
    slugs = exercises.map do |slug|
      SLUG_FORMAT % { language: language, exercise: exercise, part: part }
    end

    where("exercises.slug": slugs)
  }

  def self.exercises
    ["a", "b"]
  end

  def research_experiment_solution?
    true
  end
end
