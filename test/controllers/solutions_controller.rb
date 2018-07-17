require 'test_helper'

class SolutionsControllerTest < ActionDispatch::IntegrationTest
  test "index should be restricted to published solutions" do
    exercise = create :exercise

    create :solution, exercise: exercise, published_at: nil
    solution = create :solution, exercise: exercise, published_at: DateTime.now - 1.week

    get track_exercise_solutions_url(exercise.track, exercise)
    assert_response :success
    assert_equal assigns(:solutions), [solution]
  end

  test "show should succeed for unpublished solution" do
    exercise = create :exercise
    solution = create :solution, exercise: exercise, published_at: DateTime.now - 1.week
    create :iteration, solution: solution

    get track_exercise_solution_url(exercise.track, exercise, solution)
    assert_response :success
  end

  test "show should fail for unpublished solution" do
    exercise = create :exercise
    solution = create :solution, exercise: exercise, published_at: nil

    get track_exercise_solution_url(exercise.track, exercise, solution.uuid)
    assert_redirected_to track_exercise_url(exercise.track, exercise)
  end
end

