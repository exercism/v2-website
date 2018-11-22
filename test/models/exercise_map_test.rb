require "test_helper"

class ExerciseMapTest < ActiveSupport::TestCase
  test "returns side exercises for auto approved exercises" do
    user = create(:user)
    track = create(:track)
    exercise = create(:exercise,
                      auto_approve: true,
                      core: true,
                      track: track)
    side_exercise = create(:exercise,
                           core: false,
                           unlocked_by: nil,
                           track: track)
    unlocked_exercise = create(:exercise,
                               unlocked_by: exercise,
                               track: track)

    # Add exercises solved by others
    create(:exercise, track: track, unlocked_by: create(:exercise))
    solution = create(:solution, exercise: exercise)

    core_exercises = ExerciseMap.new(user, track).core_exercises

    assert_delegated_equal exercise, core_exercises[0].exercise
    assert_delegated_equal(
      [side_exercise, unlocked_exercise],
      core_exercises[0].unlocks
    )
  end

  test "correctly marks unlocked exercises" do
    user = create(:user)
    track = create(:track)
    exercise = create(:exercise, core: true, track: track)
    create(:solution, exercise: exercise)

    core_exercises = ExerciseMap.new(user, track).core_exercises

    refute core_exercises[0].exercise.unlocked?
  end

  private

  def assert_delegated_equal(expected, actual)
    assert_equal actual, expected
  end
end
