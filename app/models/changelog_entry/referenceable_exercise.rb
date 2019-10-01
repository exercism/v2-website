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
  end
end
