require 'test_helper'

class AbandonOverdueSolutionMentorshipsTest < ActiveSupport::TestCase
  test "abandons overdue mentorships" do
    overdue_mentorship = create :solution_mentorship, requires_action_since: Time.current - 8.days
    new_mentorship = create :solution_mentorship, requires_action_since: Time.current - 6.days
    without_action_required_mentorship = create :solution_mentorship, requires_action_since: nil
    abandoned_mentorship = create :solution_mentorship, requires_action_since: Time.current - 8.days, abandoned: true
    approved_mentorship = create :solution_mentorship, requires_action_since: Time.current - 8.days, solution: create(:solution, approved_by: create(:user))
    completed_mentorship = create :solution_mentorship, requires_action_since: Time.current - 8.days, solution: create(:solution, completed_at: Time.current)

    AbandonSolutionMentorship.expects(:call).with(overdue_mentorship, :timed_out)
    AbandonOverdueSolutionMentorships.()
  end
end
