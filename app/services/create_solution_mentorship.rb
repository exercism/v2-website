class CreateSolutionMentorship
  include Mandate

  initialize_with :solution, :user

  def call
    return existing_record if existing_record

    mentorship = SolutionMentorship.create(
      user: user,
      solution: solution
    )
    CacheSolutionNumMentors.(solution)
    mentorship
  end

  private

  def existing_record
    @existing_record ||=
      user.solution_mentorships.where(solution_id: solution.id).first
  end
end
