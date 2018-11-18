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

  test "returns locked exercises for user" do
    track = create(:track)
    user = create(:user)
    core_exercise = create(:exercise, track: track, core: true)
    other_core_exercise = create(:exercise, track: track, core: true)
    side_exercise = create(:exercise, track: track, core: false)
    create(:solution,
           user: user,
           exercise: core_exercise,
           completed_at: Date.new(2016, 12, 25))
    create(:solution,
           exercise: other_core_exercise,
           completed_at: Date.new(2016, 12, 25))

    assert_equal(
      [other_core_exercise, side_exercise].sort,
      Exercise.locked_for(user).sort
    )
  end

  test "download_command" do
    exercise = create :exercise
    expected = "exercism download --exercise=#{exercise.slug} --track=#{exercise.track.slug}"
    assert_equal expected, exercise.download_command
  end

  test "download_command with team" do
    exercise = create :exercise
    team = create :team
    expected = "exercism download --exercise=#{exercise.slug} --track=#{exercise.track.slug} --team=#{team.slug}"
    assert_equal expected, exercise.download_command(team: team)
  end
end
