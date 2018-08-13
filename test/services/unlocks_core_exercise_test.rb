require "test_helper"

class UnlocksCoreExerciseTest < ActiveSupport::TestCase
  test "unlocks core exercise" do
    user = create(:user)
    exercise = create(:exercise)
    CreateSolution.expects(:call).with(user, exercise)

    UnlocksCoreExercise.(user, exercise)
  end

  test "does not double-unlock" do
    Git::ExercismRepo.stubs(current_head: SecureRandom.uuid)

    user = create(:user)
    exercise = create(:exercise)
    user_track = create :user_track, user: user, track: exercise.track
    solution = create(:solution, user: user, exercise: exercise)

    assert_equal solution, UnlocksCoreExercise.(user, exercise)
  end
end
