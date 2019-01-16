require 'test_helper'

class AbandomOverdueSolutionMentorshipsTest < ActiveSupport::TestCase
  test "abandons overdue mentorships" do
    overdue_mentorship = create :solution_mentorship, requires_action_since: Time.current - 8.days
    new_mentorship = create :solution_mentorship, requires_action_since: Time.current - 6.days
    completed_mentorship = create :solution_mentorship, requires_action_since: nil

    AbandonSolutionMentorship.expects(:call).with(overdue_mentorship, :timed_out)
    AbandonOverdueSolutionMentorships.()
  end
end
