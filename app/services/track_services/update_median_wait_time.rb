module TrackServices
  class UpdateMedianWaitTime
    include Mandate

    def call
      mentored_solutions.group_by(&:track_id).each do |track_id, solutions|
        Track.where(id: track_id).update(
          median_wait_time: calculate_median(solutions.map(&:wait_time))
        )
      end
    end

    def mentored_solutions
      MentoredSolutionsQuery.().
        select("exercises.track_id").
        not_legacy.
        joins(:exercise).
        merge(Exercise.core).
        having("first_mentored_at >= ?", 4.weeks.ago)
    end

    def calculate_median(vals)
      vals.sort!
      len = vals.length
      median = (vals[(len - 1) / 2] + vals[len / 2]) / 2.0
    end
  end
end
