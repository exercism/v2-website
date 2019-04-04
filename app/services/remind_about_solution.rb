class RemindAboutSolution
  include Mandate

  initialize_with :solution

  def call
    return if solution.reminder_sent_at?
    return if solution.completed?
    return if solution.last_updated_by_user_at.to_i > solution.last_updated_by_mentor_at.to_i
    return if email_log.remind_about_solution_sent_at.to_i > (Time.current - 1.day).to_i

    solution.update(reminder_sent_at: Time.current)

    DeliverEmail.(
      solution.user,
      :remind_about_solution,
      solution,
      other_solutions
    )
  end

  private
  def other_solutions
    solution.user.solutions.
      where.not(id: solution.id).
      not_completed.
      where("last_updated_by_mentor_at > last_updated_by_user_at")
  end

  memoize
  def email_log
    UserEmailLog.for_user(solution.user)
  end
end

