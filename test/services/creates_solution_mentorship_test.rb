require 'test_helper'

class CreatesSolutionMentorshipTest < ActiveSupport::TestCase
  test "creates solution_mentorship and iterates num_mentors" do
    solution = create :solution
    user = create :user

    mentorship = CreatesSolutionMentorship.create(solution, user)
    assert mentorship.persisted?
    assert_equal solution, mentorship.solution
    assert_equal user, mentorship.user

    solution.reload
    assert_equal 1, solution.num_mentors
  end

  test "returns existing solution_mentorship" do
    solution = create :solution
    user = create :user
    existing_mentorship = create :solution_mentorship, solution: solution, user: user

    new_mentorship = CreatesSolutionMentorship.create(solution, user)
    assert_equal existing_mentorship, new_mentorship
  end
end

