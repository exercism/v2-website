class ChangelogEntry
  class ReferenceableExercise
    attr_reader :exercise

    delegate :to_global_id, to: :exercise

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

    def as_json(*args)
      {
        id: to_global_id.to_s,
        title: title,
      }
    end

    def key
      "exercise_#{exercise.id}"
    end

    def object
      exercise
    end
  end
end
