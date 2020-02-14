module TrackServices
  class UpdateMedianWaitTime
    include Mandate

    def call
      Track.active.each do |track|
        solutions = mentored_solutions.where('exercises.track_id': track.id)
        track.update(
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
      return nil if vals.empty?

      vals.sort!
      len = vals.length
      median = (vals[(len - 1) / 2] + vals[len / 2]) / 2.0
    end
  end
end
