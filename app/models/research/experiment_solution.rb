module Research
  class ExperimentSolution < ApplicationRecord
    include SolutionBase

    belongs_to :user
    belongs_to :exercise
    belongs_to :experiment

    has_many :submissions, as: :solution

    # Don't pass query params language into this, only pass
    # things that have been pre-parsed via Track.find_by_slu
    scope :by_language_part, -> (language_slug:, part:) {

      # Guard against unsafe parts.
      return [] unless %w{a b}.include?(part)

      slug = Research::ExerciseSlug.construct(
        language: language_slug,
        part: part,
        exercise: "%"
      )

      joins(:exercise).where("exercises.slug LIKE ?", slug)
    }

    def research_experiment_solution?
      true
    end

    def language_slug
      Research::ExerciseSlug.deconstruct(exercise.slug)[:language]
    end
  end
end
