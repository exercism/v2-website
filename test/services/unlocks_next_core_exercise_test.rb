require "test_helper"

class UnlocksNextCoreExerciseTest < ActiveSupport::TestCase
  test "unlocks next core exercise" do
    track = create(:track)
    user = create(:user)
    core_exercise = create(:exercise,
                           track: track,
                           core: true,
                           position: 1)
    next_core_exercise = create(:exercise,
                                track: track,
                                core: true,
                                position: 2)
    other_core_exercise = create(:exercise,
                                track: track,
                                core: true,
                                position: 3)
    solution = create(:solution, user: user, exercise: core_exercise)
    UnlocksCoreExercise.expects(:call).with(user, next_core_exercise)
    UnlocksCoreExercise.expects(:call).with(user, other_core_exercise).never

    UnlocksNextCoreExercise.(solution)
  end

end
