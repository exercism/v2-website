module ExerciseServices
  class UpdateMedianWaitTime
    include Mandate

    def call
      unprocessed_ids = Exercise.pluck(:id)
      mentored_solutions.group_by(&:exercise_id).each do |exercise_id, solutions|
        Exercise.find(exercise_id).update(
          median_wait_time: calculate_median(solutions.map(&:wait_time))
        )
        unprocessed_ids.delete(exercise_id)
      end
      Exercise.where(id: unprocessed_ids).update_all(median_wait_time: nil)
    end

    def mentored_solutions
      MentoredSolutionsQuery.().
        not_legacy.
        having("first_mentored_at >= ?", 4.weeks.ago)
    end

    def calculate_median(vals)
      vals.sort!
      len = vals.length
      median = (vals[(len - 1) / 2] + vals[len / 2]) / 2.0
    end

  end
end

