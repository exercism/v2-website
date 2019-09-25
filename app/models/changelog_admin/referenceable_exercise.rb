module ChangelogAdmin
  class ReferenceableExercise < SimpleDelegator
    def title
      "#{track.title} - #{exercise.title}"
    end

    private

    def exercise
      __getobj__
    end
  end
end
