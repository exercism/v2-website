require 'test_helper'

class AbandonMentoringSolutionTest < ActiveSupport::TestCase
  test "works with existing mentorship" do
    mentor = create :user_mentor
    solution = create :solution
    mentorship = create :solution_mentorship, user: mentor, solution: solution

    AbandonMentoringSolution.(mentor, solution)

    [solution, mentorship].each(&:reload)
    assert mentorship.abandoned
    assert_equal 0, solution.num_mentors
  end

  test "works without existing mentorship" do
    mentor = create :user_mentor
    solution = create :solution

    # Create a different mentor's mentorship
    create :solution_mentorship, solution: solution

    AbandonMentoringSolution.(mentor, solution)

    solution.reload

    assert SolutionMentorship.where(user: mentor, solution: solution, abandoned: true).exists?
    assert_equal 1, solution.num_mentors
  end
end
