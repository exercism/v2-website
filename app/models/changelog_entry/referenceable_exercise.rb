class ChangelogEntry
  class ReferenceableExercise
    attr_reader :exercise

    delegate :to_global_id, to: :exercise
    delegate :tweet, to: :twitter_account

    def initialize(exercise)
      @exercise = exercise
    end

    def title
      "#{exercise.track_title} - #{exercise.title}"
    end

    def icon
      exercise.dark_icon_url
    end

    def twitter_account
      ReferenceableTrack.new(exercise.track).twitter_account
    end
  end
end
