class RemindSolutionMentorship
  include Mandate

  initialize_with :solution_mentorship

  def call
    return if solution_mentorship.mentor_reminder_sent_at?

    solution_mentorship.update(mentor_reminder_sent_at: Time.current)

    DeliverEmail.(
      solution_mentorship.user,
      :remind_mentor,
      solution
    )
  end

  private
  def solution
    solution_mentorship.solution
  end
end
