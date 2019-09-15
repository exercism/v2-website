require_relative './test_base'

class API::SolutionsControllerTest < API::TestBase
  def setup
    @mock_exercise = stub(files: [])
    @mock_repo = stub(exercise: @mock_exercise,
                      ignore_regexp: /somethingtoignore/,
                      head: "4567")
    Git::ExercismRepo.stubs(new: @mock_repo)
  end

  ###
  # LATEST
  ###
  test "latest should return 401 with incorrect token" do
    get latest_api_solutions_path, as: :json
    assert_response 401
  end

  ### Errors: Track Not Found
  test "latest should return 404 when the track doesn't exist" do
    setup_user
    exercise = create :exercise, core: true
    get latest_api_solutions_path(exercise_id: exercise.slug, track_id: SecureRandom.uuid), headers: @headers, as: :json
    assert_response 404
    expected = {error: {
      type: "track_not_found",
      message: "The track you specified does not exist",
      fallback_url: tracks_url
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  ### Errors: Exercise Not Found
  test "latest should return 404 when there is no exercise" do
    setup_user
    track = create :track
    get latest_api_solutions_path(track_id: track.slug), headers: @headers, as: :json
    assert_response 404
    expected = {error: {
      type: "exercise_not_found",
      message: "The exercise you specified could not be found",
      fallback_url: track_url(track)
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "latest should return 404 when there is no valid exercise and no track specified" do
    setup_user
    get latest_api_solutions_path(exercise_id: SecureRandom.uuid), headers: @headers, as: :json
    assert_response 404
    expected = {error: {
      type: "exercise_not_found",
      message: "The exercise you specified could not be found"
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  ### Errors: Track Not Joined
  test "latest should return 403 when the track isn't joined" do
    setup_user
    track = create :track
    exercise = create :exercise, core: true, track: track
    get latest_api_solutions_path(exercise_id: exercise.slug, track_id: track.slug), headers: @headers, as: :json
    assert_response 403
    expected = {error: {
      type: "track_not_joined",
      message: "You have not joined this track"
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  ### Errors: Solution Not Unlocked
  test "index should return 403 when solution is missing" do
    setup_user
    track = create :track
    create :user_track, user: @current_user, track: track
    exercise = create :exercise, track: track, core: true

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

    assert_response 403
    expected = {error: {
      type: "solution_not_unlocked",
      message: I18n.t('api.errors.solution_not_unlocked')
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  # Errors: Track Ambiguous
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
      message: "Please specify a track ID",
      possible_track_ids: [exercise1.track.slug, exercise2.track.slug]
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  # Errors: Track Ambiguous
  test "latest should return array of possible tracks if multiple are possible with no solutions" do
    setup_user
    track1 = create :track
    track2 = create :track
    create :user_track, user: @current_user, track: track1
    create :user_track, user: @current_user, track: track2

    exercise1 = create :exercise, core: false, track: track1
    create :exercise, slug: exercise1.slug, core: false, track: track2
    create :exercise, core: false, track: track1

    get latest_api_solutions_path(exercise_id: exercise1.slug), headers: @headers, as: :json
    assert_response 400
    expected = {error: {
      type: "track_ambiguous",
      message: "Please specify a track ID",
      possible_track_ids: [track1.slug, track2.slug]
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

  test "permissions: latest should return 200 if user is solution_user" do
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

  test "permissions: latest should return 403 if user is mentor" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    create :track_mentorship, user: @current_user, track: track
    solution = create :solution, exercise: exercise
    create :user_track, user: @current_user, track: track

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

    assert_response 403
    expected = {error: {
      type: "solution_not_unlocked",
      message: I18n.t('api.errors.solution_not_unlocked')
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "permissions: latest should return 403 even if solution is published" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :solution, exercise: exercise, published_at: DateTime.yesterday
    create :user_track, user: @current_user, track: track

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
    assert_response 403
    expected = {error: {
      type: "solution_not_unlocked",
      message: I18n.t('api.errors.solution_not_unlocked')
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "permissions: latest should return 403 for a normal user when the solution is not published" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    solution = create :solution, exercise: exercise
    create :user_track, user: solution.user, track: track

    get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json
    assert_response 403
  end

  test "latest should return solution when solution is unlocked" do
    setup_user
    exercise = create :exercise, core: true
    track = exercise.track
    create :user_track, user: @current_user, track: track
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

  test "updates git slug and sha if exercise is downloaded for the first time" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :solution,
        user: @current_user,
        exercise: exercise,
        downloaded_at: nil,
        git_sha: "1234",
        git_slug: 'meh'
      create :user_track, user: solution.user, track: track

      get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

      solution.reload
      assert_equal exercise.slug, solution.git_slug
      assert_equal "4567", solution.git_sha
    end
  end

  test "does not update git sha if exercise was downloaded" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :solution,
        user: @current_user,
        exercise: exercise,
        downloaded_at: Time.utc(2016, 12, 25),
        git_sha: "1234"
      create :user_track, user: solution.user, track: track

      get latest_api_solutions_path(track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

      solution.reload
      assert_equal "1234", solution.git_sha
    end
  end

  test "updates team solution git sha if exercise is downloaded for the first time" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :team_solution,
        user: @current_user,
        exercise: exercise,
        downloaded_at: nil,
        git_sha: "1234"
      create :user_track, user: solution.user, track: track

      get latest_api_solutions_path(team_id: solution.team.slug, track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

      solution.reload
      assert_equal "4567", solution.git_sha
    end
  end

  test "does not update team solution git sha if exercise was downloaded" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :team_solution,
        user: @current_user,
        exercise: exercise,
        downloaded_at: Time.utc(2016, 12, 25),
        git_sha: "1234"
      create :user_track, user: solution.user, track: track

      get latest_api_solutions_path(team_id: solution.team.slug, track_id: track.slug, exercise_id: exercise.slug), headers: @headers, as: :json

      solution.reload
      assert_equal "1234", solution.git_sha
    end
  end


  ###
  # SHOW
  ###
  test "show should return 404 when solution is missing" do
    setup_user
    get api_solution_path(999), headers: @headers, as: :json
    assert_response 404
    expected = {error: {
      type: "solution_not_found",
      message: "This solution could not be found"
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "show should return 200 for solution if user is solution_user" do
    Timecop.freeze do
      setup_user
      exercise = create :exercise
      track = exercise.track
      solution = create :solution,
        user: @current_user,
        exercise: exercise
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
    expected = {error: {
      type: "solution_not_accessible",
      message: "You do not have permission to view this solution"
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
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
    assert_response 403
    expected = {error: {
      type: "solution_not_accessible",
      message: "You do not have permission to view this solution"
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
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
    expected = {error: {
      type: "duplicate_iteration",
      message: "No files you submitted have changed since your last iteration"
    }}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end
end
