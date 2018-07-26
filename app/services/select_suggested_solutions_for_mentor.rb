class SelectSuggestedSolutionsForMentor
  include Mandate

  MAX_RESULTS = 20

  attr_reader :user, :filtered_track_ids, :filtered_exercise_ids, :page
  def initialize(user, filtered_track_ids: nil, filtered_exercise_ids: nil, page: nil)
    @user = user
    @page = page
    @filtered_track_ids = filtered_track_ids
    @filtered_exercise_ids = filtered_exercise_ids
  end

  def call
    solution_ids = select_priority_core
    solution_ids += select_priority_side(MAX_RESULTS - solution_ids.length)
    solution_ids += select_rest(solution_ids, MAX_RESULTS - solution_ids.length)

    Solution.
      where(id: solution_ids).
      order(Arel.sql("FIND_IN_SET(id, '#{solution_ids.join(",")}')")).
      includes(iterations: [], exercise: {track: []}, user: [:profile, { avatar_attachment: :blob }])
  end

  private
  def select_priority_core
    base_fast_query.
      where('exercises.core': true).
      limit(MAX_RESULTS).
      pluck(:id)
  end

  def select_priority_side(limit)
    base_fast_query.
      where('exercises.core': false).
      limit(limit).
      pluck(:id)
  end

  def select_rest(ignore_ids, limit)
    base_query.
      where.not(id: ignore_ids).
      where("num_mentors = 0").
      order(Arel.sql("last_updated_by_user_at > '#{Exercism::V2_MIGRATED_AT.to_s(:db)}' DESC,
                      solutions.track_in_independent_mode = 0 DESC,
                      solutions.created_at > '#{Exercism::V2_MIGRATED_AT.to_s(:db)}' DESC,
                      core DESC,
                      num_mentors ASC,
                      last_updated_by_user_at ASC")).
      limit(limit).
      pluck(:id)
  end

  def base_fast_query
    base_query.
      where(num_mentors: 0).
      where("solutions.track_in_independent_mode = 0").
      where("solutions.created_at > '#{Exercism::V2_MIGRATED_AT.to_s(:db)}'").
      order(Arel.sql("last_updated_by_user_at ASC"))
  end

  def base_query
    Solution.

      # Only mentored tracks
      joins(:exercise).
      where("solutions.exercise_id": exercise_ids).

      # Not things you already mentor
      where.not(id: user.solution_mentorships.select(:solution_id)).

      # Not things you've ignored
      where.not(id: user.ignored_solution_mentorships.select(:solution_id)).

      # Not your own solutions
      where.not(user_id: user.id).

      # Where the person has posted at least one iteration
      where(id: Iteration.select(:solution_id)).

      # Not approved
      where(approved_by: nil).

      # Not completed
      where(completed_at: nil).

      # Not completed
      where(independent_mode: false)
  end

  memoize
  def exercise_ids
    eids = Exercise.where(track_id: track_ids).select(:id)
    eids = eids.where(id: filtered_exercise_ids) if filtered_exercise_ids.present?
    eids
  end

  memoize
  def track_ids
    tids = user.track_mentorships.select(:track_id)
    tids = tids.where(track_id: filtered_track_ids) if filtered_track_ids.present?
    tids
  end
end
