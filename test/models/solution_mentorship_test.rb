require 'test_helper'

class SolutionMentorshipTest < ActiveSupport::TestCase
  test "requires_action" do
    solution_mentorship = create :solution_mentorship
    solution_mentorship.update(requires_action_since: nil)
    refute solution_mentorship.requires_action?

    solution_mentorship.update(requires_action_since: Time.current)
    assert solution_mentorship.requires_action?
  end

  test "active" do
    create :user
    solution = create :solution
    active_mentor_on_solution = create :user
    active_mentor_not_on_solution = create :user
    inactive_mentor_on_solution = create :user

    active_mentorship = create :solution_mentorship, solution: solution, user: active_mentor_on_solution
    create :solution_mentorship, solution: solution, user: inactive_mentor_on_solution
    create :track_mentorship, user: active_mentor_on_solution
    create :track_mentorship, user: active_mentor_not_on_solution
    create :solution_mentorship, solution: solution, user: active_mentor_on_solution, abandoned: true

    assert_equal [active_mentorship], solution.mentorships.active
  end
end
