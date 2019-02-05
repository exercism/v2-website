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

  test "show should succeed for published solution" do
    exercise = create :exercise
    solution = create :solution, exercise: exercise, published_at: DateTime.now - 1.week
    create :iteration, solution: solution

    get track_exercise_solution_url(exercise.track, exercise, solution)
    assert_response :success
  end

  test "show should render not_published for unpublished solution with uuid" do
    sign_in!
    solution = create :solution, published_at: nil

    get solution_url(solution)
    assert_template :not_published
    assert_response :missing
  end

  test "show should redirect for unpublished for same user" do
    sign_in!
    solution = create :solution, published_at: nil, user: @current_user

    get solution_url(solution)
    assert_redirected_to my_solution_path(solution)
  end

  test "show should explode for missing solution" do
    get solution_url('1234')
    assert_template :not_found
    assert_response :missing
  end

  test "show should clear notifications" do
    exercise = create :exercise
    solution = create :solution, exercise: exercise, published_at: DateTime.now - 1.week
    user = create :user
    create :iteration, solution: solution

    create :notification, about: solution, user: user
    create :notification, about: solution # A different user
    create :notification, about: exercise, user: user # A random notification
    assert_equal 3, Notification.unread.count
    assert_equal 0, Notification.read.where(about: solution, user: user).count

    sign_in!(user)
    get track_exercise_solution_url(exercise.track, exercise, solution)
    assert_equal 2, Notification.unread.count
    assert_equal 1, Notification.read.where(about: solution, user: user).count
  end

end
