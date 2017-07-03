require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  test "instructions and testsuite come from git exercise" do
    solution = create :solution
    instructions = mock
    test_suite = mock
    git_exercise = mock(instructions: instructions, test_suite: test_suite)
    GitExercise.expects(:new).
                with(solution.exercise, solution.git_sha).
                returns(git_exercise)

    assert_equal instructions, solution.instructions
    assert_equal test_suite, solution.test_suite
  end
end
