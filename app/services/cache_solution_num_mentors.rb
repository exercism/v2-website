class CacheSolutionNumMentors
  include Mandate

  initialize_with :solution

  def call
    # Always do this in SQL to avoid races.
    Solution.where(id: solution.id).update_all(
      "num_mentors = (
        SELECT COUNT(*)
        FROM solution_mentorships
        WHERE solution_id = #{solution.id}
        AND abandoned = FALSE
        )"
    )
  end
end
