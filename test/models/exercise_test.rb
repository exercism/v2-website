require_relative "../test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "an exercise is unlocked when a user has a solution for it" do
    user = create(:user)
    exercise = create(:exercise)
    solution = create(:solution, user: user, exercise: exercise)

    assert exercise.unlocked_by_user?(user)
  end

  test "an exercise is not unlocked when a user has no solution for it" do
    user = create(:user)
    exercise = create(:exercise)

    refute exercise.unlocked_by_user?(user)
  end
end
