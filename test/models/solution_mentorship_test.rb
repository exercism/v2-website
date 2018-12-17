require 'test_helper'

class SolutionMentorshipTest < ActiveSupport::TestCase
  test "requires_action" do
    solution_mentorship = create :solution_mentorship
    solution_mentorship.update(requires_action_since: nil)
    refute solution_mentorship.requires_action?

    solution_mentorship.update(requires_action_since: Time.current)
    assert solution_mentorship.requires_action?
  end
end
