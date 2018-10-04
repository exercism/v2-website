require 'test_helper'

class RequestMentoringOnSolutionTest < ActiveSupport::TestCase
  test "sets values correctly" do
    Timecop.freeze do
      solution = create :solution,
                        mentoring_requested_at: Time.now - 1.week,
                        last_updated_by_user_at: Time.now - 1.week,
                        updated_at: Time.now - 1.week

      CancelMentoringRequestForSolution.(solution)

      solution.reload
      assert_nil solution.mentoring_requested_at
      assert_equal Time.now.to_i, solution.last_updated_by_user_at.to_i
      assert_equal Time.now.to_i, solution.updated_at.to_i
    end
  end

  test "doesn't do anyting if solution is mentored" do
    time = Time.now
    solution = create :solution, mentoring_requested_at: time
    create :solution_mentorship, solution: solution

    CancelMentoringRequestForSolution.(solution)
    assert_equal Time.now.to_i, solution.mentoring_requested_at.to_i
  end
end

