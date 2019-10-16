class ApproveSolution
  include Mandate
  include HtmlGenerationHelpers

  initialize_with :solution, :mentor

  def call
    return false unless mentor_may_approve?

    solution.update(approved_by: mentor)
    CompleteSolution.(solution) if solution.completed?

    CreateSolutionMentorship.(solution, mentor)
    solution.update!(last_updated_by_mentor_at: Time.current)

    SolutionMentorship.where(solution: solution).update_all(requires_action_since: nil)
    notify_solution_user
  end

  private

  def notify_solution_user
    CreateNotification.(
      solution.user,
      :solution_approved,
      "#{strong mentor.handle} has approved your solution to #{strong solution.exercise.title} on the #{strong solution.exercise.track.title} track.",
      routes.my_solution_url(solution),
      trigger: mentor,
      about: solution
    )

    DeliverEmail.(
      solution.user,
      :solution_approved,
      solution
    )
  end

  def mentor_may_approve?
    mentor.mentoring_track?(solution.exercise.track)
  end
end
