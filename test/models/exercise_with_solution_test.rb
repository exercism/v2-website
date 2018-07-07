require "test_helper"

class ExerciseWithSolutionTest < ActiveSupport::TestCase
  test "exercise is unlocked when solution is present" do
    exercise = create(:exercise)
    solution = create(:solution)

    object = ExerciseWithSolution.new(exercise, solution)

    assert object.unlocked?
  end

  test "exercise is locked when solution is blank" do
    exercise = create(:exercise)

    object = ExerciseWithSolution.new(exercise, nil)

    assert object.locked?
  end

  test "exercise is completed when solution is completed" do
    exercise = create(:exercise)
    solution = create(:solution, completed_at: Date.new(2016, 12, 25))

    object = ExerciseWithSolution.new(exercise, solution)

    assert object.completed?
  end
end
