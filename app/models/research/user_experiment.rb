module Research
  class UserExperiment < ApplicationRecord
    belongs_to :user
    belongs_to :experiment

    def to_param
      experiment.slug
    end

    def language_started?(lang)
      languages_started.include?(lang.to_sym)
    end

    def languages_started
      @languages_started ||=
        solutions.map {|s| s.exercise.slug.split("-").tap{|s|s.pop(2)}.join('-').to_sym}.uniq
    end

    def solutions
      ExperimentSolution.where(
        user: user,
        experiment: experiment
      ).includes(:exercise)
    end
  end
end
