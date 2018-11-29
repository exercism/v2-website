require "test_helper"

class ExerciseWithStatusTest < ActiveSupport::TestCase
  test "exercise is unlocked when solution is present" do
    exercise = create(:exercise)
    solution = create(:solution)

    object = ExerciseWithStatus.new(exercise, solution)

    assert object.unlocked?
  end

  test "exercise is locked when solution is blank" do
    exercise = create(:exercise)

    object = ExerciseWithStatus.new(exercise, nil)

    assert object.locked?
  end

  test "exercise is completed when solution is completed" do
    exercise = create(:exercise)
    solution = create(:solution, completed_at: Date.new(2016, 12, 25))

    object = ExerciseWithStatus.new(exercise, solution)

    assert object.completed?
  end

  test "exercise is approved when solution is approved" do
    exercise = create(:exercise)
    solution = create(:solution, approved_by: create(:user))

    object = ExerciseWithStatus.new(exercise, solution)

    assert object.approved?
  end

  test "exercise is in progress when solution is in progress" do
    exercise = create(:exercise)
    solution = create(:solution, downloaded_at: Time.utc(2018, 12, 25))

    object = ExerciseWithStatus.new(exercise, solution)

    assert object.in_progress?
  end

  test "status is 'Completed' when solution is completed" do
    exercise = create(:exercise)
    solution = create(:solution, completed_at: Date.new(2016, 12, 25))

    object = ExerciseWithStatus.new(exercise, solution)

    assert_equal "Completed", object.status
  end

  test "status is 'Approved' when solution is approved" do
    exercise = create(:exercise)
    solution = create(:solution, approved_by: create(:user))

    object = ExerciseWithStatus.new(exercise, solution)

    assert_equal "Approved", object.status
  end

  test "status is 'In progress' when solution is in progress" do
    exercise = create(:exercise)
    solution = create(:solution, downloaded_at: Time.utc(2018, 12, 25))

    object = ExerciseWithStatus.new(exercise, solution)

    assert_equal "In progress", object.status
  end

  test "status is 'Unlocked' when solution is unlocked" do
    exercise = create(:exercise)
    solution = create(:solution)

    object = ExerciseWithStatus.new(exercise, solution)

    assert_equal "Unlocked", object.status
  end

  test "status is 'Locked' when solution is locked" do
    exercise = create(:exercise)

    object = ExerciseWithStatus.new(exercise, nil)

    assert_equal "Locked", object.status
  end
end
