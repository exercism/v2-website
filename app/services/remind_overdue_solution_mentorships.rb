class RemindOverdueSolutionMentorships
  include Mandate

  def call
    SolutionMentorship.joins(:solution).
                       where("requires_action_since < ?", Time.current - 5.days).
                       where(mentor_reminder_sent_at: nil).
                       where('solutions.approved_by': nil).
                       where('solutions.completed_at': nil).
                       where(abandoned: false).
                       each do |mentorship|
      RemindSolutionMentorship.(mentorship)
    end
  end
end

