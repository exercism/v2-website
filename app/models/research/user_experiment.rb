module Research
  class UserExperiment < ApplicationRecord
    belongs_to :user
    belongs_to :experiment

    def to_param
      experiment.id
    end

    def language_started?(lang)
      languages_started.include?(lang.to_sym)
    end

    def languages_started
      @languages_started ||= solutions.map(&:language_slug).uniq
    end

    def solutions
      ExperimentSolution.where(
        user: user,
        experiment: experiment
      ).includes(:exercise)
    end

    def language_part(language, part)
      solutions.
        by_language_part(language_slug: language, part: part).
        first
    end
  end
end
