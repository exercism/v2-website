require "test_helper"

class UnlockNextCoreExerciseTest < ActiveSupport::TestCase
  test "unlocks a new core exercise only when all in progress core exercises are completed" do
    track = create(:track)
    user = create(:user)
    old_core_exercise = create(:exercise, track: track, core: true, position: 1)
    next_core_exercise = create(:exercise, track: track, core: true, position: 2)
    another_core_exercise = create(:exercise, track: track, core: true, position: 3)
    create(:solution,
           user: user,
           exercise: old_core_exercise,
           completed_at: Date.new(2016, 12, 25))
    next_solution = mock
    UnlockCoreExercise.expects(:call).with(user, next_core_exercise).returns(next_solution)
    UnlockCoreExercise.expects(:call).with(user, another_core_exercise).never

    assert_equal next_solution, UnlockNextCoreExercise.(track, user)
  end

  test "if existing solution exists set mentoring_requested_at and return" do
    Timecop.freeze do
      track = create(:track)
      user = create(:user)
      next_core_exercise = create(:exercise, track: track, core: true, position: 2)
      next_core_solution = create(:solution,
             user: user,
             exercise: next_core_exercise,
             completed_at: nil,
             mentoring_requested_at: nil)
      create(:iteration, solution: next_core_solution)
      UnlockCoreExercise.expects(:call).with(user, next_core_exercise).never

      assert_equal next_core_solution, UnlockNextCoreExercise.(track, user)
      assert_equal Time.current.to_i, next_core_solution.reload.mentoring_requested_at.to_i
    end
  end

  test "if existing solution don't set mentoring_requested_at if no iterations" do
    Timecop.freeze do
      track = create(:track)
      user = create(:user)
      next_core_exercise = create(:exercise, track: track, core: true, position: 2)
      next_core_solution = create(:solution,
             user: user,
             exercise: next_core_exercise,
             completed_at: nil,
             mentoring_requested_at: nil)
      UnlockCoreExercise.expects(:call).with(user, next_core_exercise).never

      assert_equal next_core_solution, UnlockNextCoreExercise.(track, user)
      assert_nil next_core_solution.reload.mentoring_requested_at
    end
  end

  test "does not override mentoring_requested_at" do
    mentoring_requested_at = Time.current - 6.weeks
    track = create(:track)
    user = create(:user)
    next_core_exercise = create(:exercise, track: track, core: true, position: 2)
    next_core_solution = create(:solution,
           user: user,
           exercise: next_core_exercise,
           completed_at: nil,
           mentoring_requested_at: mentoring_requested_at)
    UnlockCoreExercise.expects(:call).with(user, next_core_exercise).never

    assert_equal next_core_solution, UnlockNextCoreExercise.(track, user)
    assert_equal mentoring_requested_at.to_i, next_core_solution.reload.mentoring_requested_at.to_i
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
    UnlockCoreExercise.expects(:call).with(user, next_core_exercise)
    UnlockCoreExercise.expects(:call).with(user, other_core_exercise).never

    UnlockNextCoreExercise.(track, user)
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
    UnlockCoreExercise.expects(:call).with(user, old_core_exercise)
    UnlockCoreExercise.expects(:call).with(user, next_core_exercise).never

    UnlockNextCoreExercise.(track, user)
  end

  test "does not unlock side exercise" do
    track = create(:track)
    user = create(:user)

    side_exercise = create(:exercise,
                           track: track,
                           core: false,
                           position: 2)

    UnlockCoreExercise.expects(:call).with(user, side_exercise).never
    UnlockNextCoreExercise.(track, user)
  end
end
