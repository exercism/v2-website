require "test_helper"

class ExerciseWithUnlockedExercisesTest < ActiveSupport::TestCase
  test "returns unlocked exercises for an exercise" do
    exercise = create(:exercise)
    unlocked_exercise = create(:exercise, unlocked_by: exercise)
    locked_exercise = create(:exercise, unlocked_by: exercise)
    user = create(:user)
    create(:solution, exercise: unlocked_exercise, user: user)

    exercise = ExerciseWithUnlockedExercises.new(exercise, user)

    assert_delegated_equal [unlocked_exercise], exercise.unlocked_exercises
  end

  def assert_delegated_equal(first, second)
    second == first
  end
end
