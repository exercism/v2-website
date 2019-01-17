class AbandonOverdueSolutionMentorships
  include Mandate

  def call
    SolutionMentorship.where("requires_action_since < ?", Time.current - 7.days).
                       where(abandoned: false).
                       each do |mentorship|
      AbandonSolutionMentorship.(mentorship, :timed_out)
    end
  end
end
