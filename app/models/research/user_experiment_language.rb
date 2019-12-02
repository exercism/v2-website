module Research
  class UserExperimentLanguage
    attr_reader :user_experiment, :language

    def initialize(user_experiment, language)
      @user_experiment = user_experiment
      @language = language
    end

    def part(part)
      user_experiment.find_part(language: language, part: part)
    end

    def title
      Track.
        find_by(slug: language).
        title
    end
  end
end
