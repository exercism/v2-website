require "test_helper"

class UnlocksNextCoreExerciseTest < ActiveSupport::TestCase
  test "unlocks next core exercise" do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
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

    UnlocksNextCoreExercise.(solution)

    assert next_core_exercise.unlocked_by_user?(user)
    refute other_core_exercise.unlocked_by_user?(user)
  end

  test "does not double-unlock core" do
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
    create(:solution, user: user, exercise: next_core_exercise)
    solution = create(:solution, user: user, exercise: core_exercise)

    UnlocksNextCoreExercise.(solution)

    assert_equal 1, Solution.where(user: user, exercise: next_core_exercise).count
  end
end
