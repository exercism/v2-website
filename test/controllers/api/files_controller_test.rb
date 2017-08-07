require_relative './test_base'

class API::FilesControllerTest < API::TestBase

  def setup
    @mock_exercise = stub(read_file: "")
    @mock_repo = stub(exercise: @mock_exercise)
    Git::ExercismRepo.stubs(new: @mock_repo)
  end

  test "show should return 401 with incorrect token" do
    get api_solution_file_path(1, "foobar"), as: :json
    assert_response 401
  end

  test "show should return 404 when solution is missing" do
    setup_user
    get api_solution_file_path(999, "foobar"), headers: @headers, as: :json
    assert_response 404
  end

  test "show should return 200 if user is solution_user" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :solution, user: @current_user, exercise: exercise
      create :user_track, user: solution.user, track: track

      get api_solution_file_path(solution, "foobar"), headers: @headers, as: :json
      assert_response :success
    end
  end

  test "show should return 200 if user is mentor" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    create :track_mentorship, user: @current_user, track: track
    solution = create :solution, exercise: exercise
    create :user_track, user: solution.user, track: track

    get api_solution_file_path(solution, "foobar"), headers: @headers, as: :json
    assert_response :success
  end

  test "show should return 200 if solution is published" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    solution = create :solution, exercise: exercise, published_at: DateTime.yesterday
    create :user_track, user: solution.user, track: track

    get api_solution_file_path(solution, "foobar"), headers: @headers, as: :json
    assert_response :success

    solution.reload
    assert_nil solution.downloaded_at
  end

  test "show should return 403 for a normal user when the solution is not published" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    solution = create :solution, exercise: exercise
    create :user_track, user: solution.user, track: track

    get api_solution_file_path(solution, "foobar"), headers: @headers, as: :json
    assert_response 403
  end

  ["foobar", "foobar.cs", "subdir/foobar.rb"].each do |filepath|
    test "show file works with #{filepath}" do
      setup_user
      solution = create :solution, user: @current_user

      content = "qweqweqwe"
      @mock_exercise.expects(:read_file).with(filepath).returns(content)
      get "/api/v1/solutions/#{solution.uuid}/files/#{filepath}", headers: @headers, as: :json
      assert_response 200
      assert content, response.body
    end
  end

  test "gets solution file" do
    setup_user
    solution = create :solution, user: @current_user
    iteration = create :iteration, solution: solution
    file = create :iteration_file, iteration: iteration

    @mock_exercise.expects(:read_file).never

    get "/api/v1/solutions/#{solution.uuid}/files/#{file.filename}", headers: @headers, as: :json
    assert_response 200
    assert file.file_contents, response.body
  end
end
