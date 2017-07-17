require_relative './test_base'

class API::SolutionsControllerTest < API::TestBase
  test "index should return 401 with incorrect token" do
    get api_track_exercise_solutions_path(1,2), as: :json
    assert_response 401
  end

  test "index should return 403 when solution is not unlocked" do
    setup_user
    exercise = create :exercise
    track = exercise.track

    get api_track_exercise_solutions_path(track.slug, exercise.slug), headers: @headers, as: :json

    assert_response 403
  end

  test "index should return solution when solution is unlocked" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    create :solution, user: @current_user, exercise: exercise

    get api_track_exercise_solutions_path(track.slug, exercise.slug), headers: @headers, as: :json

    assert_response :success
    output = JSON.parse(response.body, symbolize_names: true)
    assert output[:solution]
  end

  test "update should create iteration" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    solution = create :solution, user: @current_user, exercise: exercise
    code = "Some code here"

    CreatesIteration.expects(:create!).with(solution, code)

    patch api_track_exercise_solution_path(track.slug, exercise.slug, solution.id, code: code), headers: @headers, as: :json

    assert_response :success
  end
end
