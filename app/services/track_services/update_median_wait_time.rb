module TrackServices
  class UpdateMedianWaitTime
    include Mandate

    def call
      ActiveRecord::Base.connection.execute(
        <<~SQL
          UPDATE `tracks`
          INNER JOIN (#{track_wait_times.to_sql}) wait_times
          ON wait_times.track_id = tracks.id
          SET tracks.median_wait_time = wait_times.median_wait_time
        SQL
      )
    end

    private

    def track_wait_times
      Track.
        select("track_id, AVG(wait_time) as median_wait_time").
        from(mentored_solutions_grouped_by_track).
        where("group_position BETWEEN group_total_count / 2.0 AND (group_total_count / 2.0 + 1)").
        group(:track_id)
    end

    def mentored_solutions_grouped_by_track
      Solution.
        select(
          <<~SQL
            mentored_solutions.track_id,
            wait_time,
            @group_position := CASE
              WHEN @current_group = mentored_solutions.track_id THEN @group_position + 1
              ELSE (@current_group := mentored_solutions.track_id) AND 1
            END AS group_position,
            group_total_count
          SQL
        ).
        from(
          <<~SQL
            (SELECT @group_position := 0, @current_group := 0) s,
            (#{mentored_solutions.to_sql}) mentored_solutions
          SQL
        ).
        joins(
          <<~SQL
            INNER JOIN (#{mentored_solutions_count.to_sql}) mentored_solutions_count
            ON mentored_solutions_count.track_id = mentored_solutions.track_id
          SQL
        ).
        order("mentored_solutions.track_id, mentored_solutions.wait_time")
    end

    def mentored_solutions_count
      Solution.
        select("track_id, COUNT(*) as group_total_count").
        from(mentored_solutions).
        group(:track_id)
    end

    def mentored_solutions
      MentoredSolutionsQuery.().
        select("exercises.track_id").
        not_legacy.
        joins(:exercise).
        merge(Exercise.core).
        having("first_mentored_at >= ?", 4.weeks.ago)
    end
  end
end
