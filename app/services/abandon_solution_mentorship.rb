class AbandonSolutionMentorship
  include Mandate

  initialize_with :solution_mentorship

  def call
    solution_mentorship.update!(abandoned: true)
    CacheSolutionNumMentors.(solution_mentorship.solution)
  end
end

