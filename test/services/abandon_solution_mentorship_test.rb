require 'test_helper'

class AbandonSolutionMentorshipTest < ActiveSupport::TestCase
  test "works with existing mentorship" do
    mentor = create :user_mentor
    solution = create :solution
    mentorship = create :solution_mentorship, user: mentor, solution: solution

    AbandonSolutionMentorship.(mentorship)

    [solution, mentorship].each(&:reload)
    assert mentorship.abandoned
    assert_equal 0, solution.num_mentors
  end
end
