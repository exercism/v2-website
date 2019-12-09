module Research
  class ExperimentSolution < ApplicationRecord
    include SolutionBase

    belongs_to :user
    belongs_to :exercise
    belongs_to :experiment

    has_many :submissions, as: :solution

    delegate :test_messages, to: :git_exercise

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

    def boilerplate_files
      git_exercise.solution_files
    end

    def latest_files
      files = boilerplate_files
      last_submission = submissions.last

      last_submission.files.each do |filename, code|
        next unless files[filename]
        files[filename] = code
      end if last_submission

      files
    end

    def submit!(time: Time.current)
      update!(finished_at: time)
    end

    def user_experiment
      UserExperiment.find_by(user: user, experiment: experiment)
    end
  end
end
