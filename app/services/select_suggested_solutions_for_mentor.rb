class SelectSuggestedSolutionsForMentor
  include Mandate

  MAX_RESULTS = 20

  attr_reader :filterer
  def initialize(user, filtered_track_ids: nil, filtered_exercise_ids: nil)
    @filterer = SolutionsToBeMentored.new(user, filtered_track_ids, filtered_exercise_ids)
  end

  def call
    solution_ids = select(:new_core_solutions, MAX_RESULTS)
    solution_ids += select(:legacy_core_solutions, MAX_RESULTS - solution_ids.length)
    solution_ids += select(:new_side_solutions, MAX_RESULTS - solution_ids.length)
    solution_ids += select(:legacy_side_solutions, MAX_RESULTS - solution_ids.length)
    solution_ids += select(:independent_solutions, MAX_RESULTS - solution_ids.length)
    solution_ids += select(:other_solutions, MAX_RESULTS - solution_ids.length, solution_ids)

    Solution.
      where(id: solution_ids).
      order(Arel.sql("FIND_IN_SET(id, '#{solution_ids.join(",")}')")).
      includes(iterations: [], exercise: {track: []}, user: [:profile, { avatar_attachment: :blob }])
  end

  def select(query, limit, *args)
    filterer.send(query, *args).limit(limit).pluck(:id)
  end
end
