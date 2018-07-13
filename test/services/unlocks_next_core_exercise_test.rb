require "test_helper"

class UnlocksNextCoreExerciseTest < ActiveSupport::TestCase
  test "unlocks a new core exercise only when all in progress core exercises are completed" do
    track = create(:track)
    user = create(:user)
    core_exercise = create(:exercise, track: track, core: true, position: 1)
    old_core_exercise = create(:exercise, track: track, core: true)
    next_core_exercise = create(:exercise, track: track, core: true, position: 2)
    create(:solution,
           user: user,
           exercise: old_core_exercise,
           completed_at: nil)
    create(:solution,
           user: user,
           exercise: core_exercise,
           completed_at: Date.new(2016, 12, 25))
    UnlocksCoreExercise.expects(:call).with(user, next_core_exercise).never

    UnlocksNextCoreExercise.(track, user)
  end

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
    create(:solution,
           user: user,
           exercise: core_exercise,
           completed_at: Date.new(2016, 12, 25))
    UnlocksCoreExercise.expects(:call).with(user, next_core_exercise)
    UnlocksCoreExercise.expects(:call).with(user, other_core_exercise).never

    UnlocksNextCoreExercise.(track, user)
  end

  test "unlocks oldest core exercise not completed" do
    track = create(:track)
    user = create(:user)
    core_exercise = create(:exercise,
                           track: track,
                           core: true,
                           position: 2)
    old_core_exercise = create(:exercise,
                                track: track,
                                core: true,
                                position: 1)
    next_core_exercise = create(:exercise,
                                track: track,
                                core: true,
                                position: 3)
    create(:solution,
           user: user,
           exercise: core_exercise,
           completed_at: Date.new(2016, 12, 25))
    UnlocksCoreExercise.expects(:call).with(user, old_core_exercise)
    UnlocksCoreExercise.expects(:call).with(user, next_core_exercise).never

    UnlocksNextCoreExercise.(track, user)
  end

  test "does not unlock side exercise" do
    track = create(:track)
    user = create(:user)

    side_exercise = create(:exercise,
                           track: track,
                           core: false,
                           position: 2)

    UnlocksCoreExercise.expects(:call).with(user, side_exercise).never
    UnlocksNextCoreExercise.(track, user)
  end
end
