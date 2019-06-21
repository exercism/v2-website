class SolutionsToBeMentored
  include Mandate

  def self.index_of_core_solution(solution)
    {
      track: new(nil, solution.exercise.track_id, nil).index_of_core_solution(solution) || 1,
      exercise: new(nil, solution.exercise.track_id, solution.exercise_id).index_of_core_solution(solution) || 1
    }
  rescue => e
    # I don't trust this method yet, so let's guard.
    Bugsnag.notify(e)

    {track: 1, exercise: 1}
  end

  initialize_with :user, :filtered_track_ids, :filtered_exercise_ids

  def all_solutions
    base_user_query
  end

  def core_solutions
    base_user_query.where('exercises.core': true)
  end

  def side_solutions
    base_user_query.where('exercises.core': false)
  end

  def new_core_solutions
    base_mentored_mode_new_query.
      where('exercises.core': true)
  end

  def new_side_solutions
    base_mentored_mode_new_query.
      where('exercises.core': false)
  end

  def legacy_core_solutions
    base_mentored_mode_legacy_query.
      where('exercises.core': true)
  end

  def legacy_side_solutions
    base_mentored_mode_legacy_query.
      where('exercises.core': false)
  end

  def independent_solutions
    base_user_query.
      where("solutions.track_in_independent_mode": true).
      order(Arel.sql("last_updated_by_user_at ASC"))
  end

  def other_solutions(ignore_ids)
    base_user_query.
      where.not(id: ignore_ids).
      order(Arel.sql("last_updated_by_user_at ASC"))
  end

  def index_of_core_solution(solution)
    inner_query = base_query.where('exercises.core': true).
                             joins("JOIN (SELECT @position := 0) r").
                             select("solutions.id, @position := @position + 1 AS position")

    sql = %Q{
      SELECT s.position
      FROM (#{inner_query.to_sql}) s
      WHERE s.id = "#{solution.id}"
    }

    ActiveRecord::Base.connection.select_value(sql).try(&:to_i)
  end

  private

  def base_mentored_mode_new_query
    base_mentored_mode_query.
      not_legacy
  end

  def base_mentored_mode_legacy_query
    base_mentored_mode_query.
      legacy.
      where("solutions.last_updated_by_user_at > ?", Exercism::V2_MIGRATED_AT.to_s(:db))
  end

  def base_mentored_mode_query
    base_user_query.
      where("solutions.track_in_independent_mode": false).
      order(Arel.sql("last_updated_by_user_at ASC"))
  end

  def base_user_query
    base_query.

      # Not things you already mentor
      where.not(id: user.solution_mentorships.select(:solution_id)).

      # Not things you've ignored
      where.not(id: user.ignored_solution_mentorships.select(:solution_id)).

      # Not your own solutions
      where.not(user_id: user.id)
  end

  def base_query
    Solution.

      # Only users who have used the site in the last 60days
      joins(:user).
      where("users.current_sign_in_at > ?", Date.today - 2.months).

      # Only mentored tracks
      joins(:exercise).
      where("solutions.exercise_id": exercise_ids).

      # Where the person has posted at least one iteration
      where(id: Iteration.select(:solution_id)).

      # Not approved
      where(approved_by: nil).

      # Not completed
      where(completed_at: nil).

      # Where mentoring has been requested
      where.not(mentoring_requested_at: nil).

      # Where there are no mentors
      where(num_mentors: 0).

      # Where not locked by a different mentor
      where("NOT EXISTS(SELECT NULL FROM solution_locks
                        WHERE solution_locks.solution_id = solutions.id
                        AND locked_until > ?
                        AND user_id != ?)", Time.current, user ? user.id : 0)
  end

  memoize
  def exercise_ids
    eids = Exercise.where(track_id: track_ids).select(:id)
    eids = eids.where(id: filtered_exercise_ids) if filtered_exercise_ids.present?
    eids
  end

  memoize
  def track_ids
    if user
      tids = user.track_mentorships.select(:track_id)
      tids = tids.where(track_id: filtered_track_ids) if filtered_track_ids.present?
      tids
    elsif filtered_track_ids.present?
      Track.where(id: filtered_track_ids).select(:id)
    else
      Track.select(:id)
    end
  end
end
