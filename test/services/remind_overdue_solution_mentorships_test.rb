require 'test_helper'

class RemindOverdueSolutionMentorshipsTest < ActiveSupport::TestCase
  test "reminds overdue mentorships" do
    overdue_mentorship = create :solution_mentorship, requires_action_since: Time.current - 6.days
    new_mentorship = create :solution_mentorship, requires_action_since: Time.current - 4.days
    without_action_required_mentorship = create :solution_mentorship, requires_action_since: nil
    abandoned_mentorship = create :solution_mentorship, requires_action_since: Time.current - 6.days, abandoned: true
    approved_mentorship = create :solution_mentorship, requires_action_since: Time.current - 6.days, solution: create(:solution, approved_by: create(:user))
    completed_mentorship = create :solution_mentorship, requires_action_since: Time.current - 6.days, solution: create(:solution, completed_at: Time.current)
    reminder_sent_mentorship = create :solution_mentorship, requires_action_since: Time.current - 6.days, mentor_reminder_sent_at: Time.now

    RemindSolutionMentorship.expects(:call).with(overdue_mentorship)
    RemindOverdueSolutionMentorships.()
  end
end

