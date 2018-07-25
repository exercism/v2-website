require "test_helper"

class UnlocksCoreExerciseTest < ActiveSupport::TestCase
  test "unlocks core exercise" do
    user = create(:user)
    exercise = create(:exercise)
    CreateSolution.expects(:call).with(user, exercise)

    UnlocksCoreExercise.(user, exercise)
  end

  test "does not double-unlock" do
    user = create(:user)
    exercise = create(:exercise)
    create(:solution, user: user, exercise: exercise)
    CreateSolution.expects(:call).with(user, exercise).never

    UnlocksCoreExercise.(user, exercise)
  end
end
