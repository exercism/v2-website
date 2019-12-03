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
      slug = Research::ExerciseSlug.construct(
        language: language_slug,
        part: part.to_i,
        exercise: "%"
      )

      joins(:exercise).where("exercises.slug LIKE ?", slug)
    }

    def research_experiment_solution?
      true
    end

    def finished?
      finished_at.present?
    end

    def language_slug
      Research::ExerciseSlug.deconstruct(exercise.slug)[:language]
    end
  end

  def code
    <<~CODE
      class TwoFer
        def self.two_fer(name="you")
          "One for %s, one for me." % name
        end
      end
    CODE
  end
end
