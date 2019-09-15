module ExerciseServices
  class UpdateMedianWaitTime
    include Mandate

    def call
      ActiveRecord::Base.connection.execute(
        <<~SQL
          UPDATE `exercises`
          INNER JOIN (#{exercise_wait_times.to_sql}) wait_times
          ON wait_times.exercise_id = exercises.id
          SET exercises.median_wait_time = wait_times.median_wait_time
        SQL
      )
    end

    private

    def exercise_wait_times
      Exercise.
        select("exercise_id, AVG(wait_time) as median_wait_time").
        from(mentored_solutions_grouped_by_exercise).
        where("group_position BETWEEN group_total_count / 2.0 AND (group_total_count / 2.0 + 1)").
        group(:exercise_id)
    end

    def mentored_solutions_grouped_by_exercise
      Solution.
        select(
          <<~SQL
            mentored_solutions.exercise_id,
            wait_time,
            @group_position := CASE
              WHEN @current_group = mentored_solutions.exercise_id THEN @group_position + 1
              ELSE (@current_group := mentored_solutions.exercise_id) AND 1
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
            ON mentored_solutions_count.exercise_id = mentored_solutions.exercise_id
          SQL
        ).
        order("mentored_solutions.exercise_id, mentored_solutions.wait_time")
    end

    def mentored_solutions_count
      Solution.
        select("exercise_id, COUNT(*) as group_total_count").
        from(mentored_solutions).
        group(:exercise_id)
    end

    def mentored_solutions
      MentoredSolutionsQuery.().
        not_legacy.
        having("first_mentored_at >= ?", 4.weeks.ago)
    end
  end
end

