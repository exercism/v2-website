module ExerciseServices
  class UpdateMedianWaitTime
    include Mandate

    def call
      Exercise.all.each do |exercise|
        solutions = mentored_solutions.where(exercise_id: exercise.id)
        exercise.update(
          median_wait_time: calculate_median(solutions.map(&:wait_time))
        )
      end
    end

    def mentored_solutions
      MentoredSolutionsQuery.().
        not_legacy.
        having("first_mentored_at >= ?", 4.weeks.ago)
    end

    def calculate_median(vals)
      return nil if vals.empty?

      vals.sort!
      len = vals.length
      median = (vals[(len - 1) / 2] + vals[len / 2]) / 2.0
    end
  end
end

