class AbandonOverdueSolutionMentorships
  include Mandate

  def call
    SolutionMentorship.joins(:solution).
                       where("requires_action_since < ?", Time.current - 7.days).
                       where('solutions.approved_by': nil).
                       where('solutions.completed_at': nil).
                       where(abandoned: false).
                       each do |mentorship|
      AbandonSolutionMentorship.(mentorship, :timed_out)
    end
  end
end
