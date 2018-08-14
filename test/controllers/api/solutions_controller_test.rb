require_relative './test_base'

class API::SolutionsControllerTest < API::TestBase
  def setup
    @mock_exercise = stub(files: [])
    @mock_repo = stub(exercise: @mock_exercise, ignore_regexp: /somethingtoignore/)
    Git::ExercismRepo.stubs(new: @mock_repo)
  end

  ###
  # LATEST
  ###
  test "latest should return 401 with incorrect token" do
    get latest_api_solutions_path, as: :json
    assert_response 401
  end

  test "latest should return 404 when the track doesn't exist" do
    setup_user
    exercise = create :exercise, core: true
    get latest_api_solutions_path(exercise_id: exercise.slug, track_id: SecureRandom.uuid), headers: @headers, as: :json
    assert_response 404
    expected = {error: {
      type: "track_not_found",
      message: "Track not found",
      fallback_url: tracks_url
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "latest should return 404 when there is no exercise" do
    setup_user
    track = create :track
    get latest_api_solutions_path(track_id: track.slug), headers: @headers, as: :json
    assert_response 404
    expected = {error: {
      type: "exercise_not_found",
      message: "Exercise not found",
      fallback_url: track_url(track)
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "latest should return 200 when the track can be guessed" do
    setup_user
    exercise = create :exercise, core: true
    create :solution, user: @current_user, exercise: exercise
    create :user_track, user: @current_user, track: exercise.track
    get latest_api_solutions_path(exercise_id: exercise.slug), headers: @headers, as: :json
    assert_response 200
  end

  test "latest should return array of possible tracks if multiple are possible" do
    setup_user
    exercise1 = create :exercise, core: true
    exercise2 = create :exercise, slug: exercise1.slug, core: true
    exercise3 = create :exercise, core: true

    create :solution, user: @current_user, exercise: exercise1
    create :solution, user: @current_user, exercise: exercise2
    create :solution, user: @current_user, exercise: exercise3

    get latest_api_solutions_path(exercise_id: exercise1.slug), headers: @headers, as: :json
    assert_response 400
    expected = {error: {
      type: "track_ambiguous",
      message: "Please specify a track id",
      possible_track_ids: [exercise1.track.slug, exercise2.track.slug]
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "index should return 404 when solution is missing" do
    setup_user
    track = create :track
    exercise = create :exercise, track: track, core: true

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

    assert_response 404
  end

  test "latest should return 200 for a locked exercise in independent mode" do
    setup_user
    track = create :track
    core = create :exercise, track: track
    exercise = create :exercise, unlocked_by: core, track: track
    create :solution, user: @current_user, exercise: exercise
    create :user_track, user: @current_user, track: track
    get latest_api_solutions_path(exercise_id: exercise.slug), headers: @headers, as: :json
    assert_response 200
  end

  test "latest should return 200 if user is solution_user" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise, core: true
      track = exercise.track
      solution = create :solution, user: @current_user, exercise: exercise
      create :user_track, user: solution.user, track: track

      get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
      assert_response :success

      solution.reload
      assert_equal solution.downloaded_at.to_i, DateTime.now.to_i
    end
  end

  test "latest should return 404 if user is mentor" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    create :track_mentorship, user: @current_user, track: track
    solution = create :solution, exercise: exercise
    create :user_track, user: solution.user, track: track

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
    assert_response 404
  end

  test "latest should return 404 even if solution is published" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :solution, exercise: exercise, published_at: DateTime.yesterday
    create :user_track, user: solution.user, track: track

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
    assert_response 404
  end

  test "latest should return 404 for a normal user when the solution is not published" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :solution, exercise: exercise
    create :user_track, user: solution.user, track: track

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
    assert_response 404
  end

  test "latest should return solution when solution is unlocked" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :solution, user: @current_user, exercise: exercise

    expected = {foo: 'bar'}
    responder = mock(to_hash: expected)
    API::SolutionResponder.expects(:new).returns(responder)

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

    assert_response :success
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  ###
  # LATEST FOR TEAMS
  ###
  test "latest should return 200 for team_solution" do
    Timecop.freeze do
      setup_user

      team = create :team
      exercise = create :exercise, core: true
      solution = create :team_solution, user: @current_user, exercise: exercise, team: team

      get latest_api_solutions_path(team_id: team.slug, track_id: exercise.track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
      assert_response :success

      solution.reload
      assert_equal solution.downloaded_at.to_i, DateTime.now.to_i
    end
  end

  test "latest should return 404 for team_solution if exercise is wrong" do
    Timecop.freeze do
      setup_user

      team = create :team
      exercise = create :exercise, core: true
      solution = create :team_solution, user: @current_user, exercise: exercise, team: team

      get latest_api_solutions_path(team_id: team.slug, track_id: exercise.track.slug, exercise_id: "foobar"), headers: @headers, as: :json
      assert_response 404
    end
  end

  test "latest should return 404 for team_solution if track is wrong" do
    Timecop.freeze do
      setup_user

      team = create :team
      exercise = create :exercise, core: true
      solution = create :team_solution, user: @current_user, exercise: exercise, team: team

      get latest_api_solutions_path(team_id: team.slug, track_id: "vasdasd", exercise_id: exercise.slug), headers: @headers, as: :json
      assert_response 404
    end
  end

  test "latest should return 404 for team_solution if team is wrong" do
    Timecop.freeze do
      setup_user

      team = create :team
      exercise = create :exercise, core: true
      solution = create :team_solution, user: @current_user, exercise: exercise, team: team

      get latest_api_solutions_path(team_id: "asdasdqweqw", track_id: exercise.track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
      assert_response 404
    end
  end

  ###
  # SHOW
  ###
  test "show should return 404 when solution is missing" do
    setup_user
    get api_solution_path(999), headers: @headers, as: :json
    assert_response 404
  end

  test "show should return 200 for solution if user is solution_user" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :solution, user: @current_user, exercise: exercise
      create :user_track, user: solution.user, track: track

      get api_solution_path(solution), headers: @headers, as: :json
      assert_response :success

      solution.reload
      assert_equal solution.downloaded_at.to_i, DateTime.now.to_i
    end
  end

  test "show should return 200 for team_solution if user is solution_user" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :team_solution, user: @current_user, exercise: exercise

      get api_solution_path(solution), headers: @headers, as: :json
      assert_response :success

      solution.reload
      assert_equal solution.downloaded_at.to_i, DateTime.now.to_i
    end
  end

  test "show should return 200 if user is mentor" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    create :track_mentorship, user: @current_user, track: track
    solution = create :solution, exercise: exercise
    create :user_track, user: solution.user, track: track

    get api_solution_path(solution), headers: @headers, as: :json
    assert_response :success

    solution.reload
    assert_nil solution.downloaded_at
  end

  test "show should return 200 if solution is published" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    solution = create :solution, exercise: exercise, published_at: DateTime.yesterday
    create :user_track, user: solution.user, track: track

    get api_solution_path(solution), headers: @headers, as: :json
    assert_response :success

    solution.reload
    assert_nil solution.downloaded_at
  end

  test "show should return 200 for team_solution if user is teammate" do
    setup_user
    team = create :team
    exercise = create :exercise

    teammate = create :user
    create :team_membership, user: @current_user, team: team

    solution = create :team_solution, exercise: exercise, team: team, user: teammate

    get api_solution_path(solution), headers: @headers, as: :json
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

    get api_solution_path(solution), headers: @headers, as: :json
    assert_response 403
  end

  test "show should return solution when solution is unlocked" do
    setup_user
    exercise = create :exercise
    track = exercise.track
    solution = create :solution, user: @current_user, exercise: exercise

    expected = {foo: 'bar'}
    responder = mock(to_hash: expected)
    API::SolutionResponder.expects(:new).returns(responder)

    get api_solution_path(solution), headers: @headers, as: :json

    assert_response :success
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  ###
  # UPDATE
  ###
  test "update should return 401 with incorrect token" do
    patch api_solution_path(1), headers: @headers, as: :json
    assert_response 401
  end

  test "update should 404 if the solution doesn't exist" do
    setup_user
    patch api_solution_path(999), headers: @headers, as: :json
    assert_response 404
  end

  test "update should 404 if the solution belongs to someone else" do
    setup_user
    solution = create :solution
    patch api_solution_path(solution), headers: @headers, as: :json
    assert_response 404
  end

  test "update should create iteration" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :solution, user: @current_user, exercise: exercise

    file = File.open(__FILE__)
    CreateIteration.expects(:call).with do |passed_solution, files|
      assert_equal solution, passed_solution
    end

    patch api_solution_path(solution),
          params: {
            files: [ file, file ]
          },
          headers: @headers,
          as: :json

    assert_response :success
  end

  test "update should succeed with team_solution" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :team_solution, user: @current_user, exercise: exercise

    file = File.open(__FILE__)
    CreateIteration.expects(:call).with do |passed_solution, files|
      assert_equal solution, passed_solution
    end

    patch api_solution_path(solution),
          params: {
            files: [ file, file ]
          },
          headers: @headers,
          as: :json
    assert_response :success
  end

  test "update should catch duplicate iteration" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :solution, user: @current_user, exercise: exercise

    CreateIteration.expects(:call).raises(DuplicateIterationError)

    file = File.open(__FILE__)
    patch api_solution_path(solution),
          params: { files: [ file, file ] },
          headers: @headers,
          as: :json

    assert_response 400
    assert_equal 'duplicate_iteration', JSON.parse(response.body, symbolize_names: true)[:error][:type]
  end
end
