class AbandonMentoringSolution
  include Mandate

  initialize_with :mentor, :solution

  def call
    solution_mentorship.update(abandoned: true)
    CacheSolutionNumMentors.(solution)
  end

  private

  memoize
  def solution_mentorship
    SolutionMentorship.where(user: mentor, solution: solution).first ||
    CreateSolutionMentorship.(solution, mentor)
  end
end

