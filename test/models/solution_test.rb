require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  test "instructions and test suite come from git exercise" do
    solution = create :solution
    instructions = mock
    test_suite = mock
    git_exercise = mock(instructions: instructions, test_suite: test_suite)
    Git::Exercise.expects(:new).
                with(solution.exercise, solution.git_slug, solution.git_sha).
                returns(git_exercise)

    assert_equal instructions, solution.instructions
    assert_equal test_suite, solution.test_suite
  end

  test "uuid has no hyphens" do
    solution = create :solution
    refute solution.uuid.include?('-')
  end

  test "returns auto approved" do
    exercise = build(:exercise, auto_approve: true)
    solution = build(:solution, exercise: exercise)

    assert solution.auto_approve?

    exercise = build(:exercise, auto_approve: false)
    solution = build(:solution, exercise: exercise)

    refute solution.auto_approve?
  end

  test "active_mentors" do
    solution = create :solution
    active_mentor_on_solution = create :user
    active_mentor_not_on_solution = create :user
    inactive_mentor_on_solution = create :user

    create :solution_mentorship, solution: solution, user: active_mentor_on_solution
    create :solution_mentorship, solution: solution, user: inactive_mentor_on_solution
    create :track_mentorship, user: active_mentor_on_solution
    create :track_mentorship, user: active_mentor_not_on_solution

    assert_equal [active_mentor_on_solution], solution.active_mentors
  end
end
