require 'test_helper'

class API::SolutionResponderTest < ActiveSupport::TestCase
  def setup
    @mock_exercise = stub(files: [])
    @mock_repo = stub(exercise: @mock_exercise, ignore_regexp: /example/i)
    Git::ExercismRepo.stubs(new: @mock_repo)
  end

  test "basic to_hash" do
    solution = create :solution
    user_track = create :user_track, user: solution.user, track: solution.exercise.track
    responder = API::SolutionResponder.new(solution, solution.user)
    expected = {
      solution: {
        id: solution.uuid,
        url: "https://test.exercism.io/my/solutions/#{solution.uuid}",
        team: nil,
        user: {
          handle: solution.user.handle,
          is_requester: true
        },
        exercise: {
          id: solution.exercise.slug,
          instructions_url: "https://test.exercism.io/my/solutions/#{solution.uuid}",
          auto_approve: solution.exercise.auto_approve,
          track: {
            id: solution.exercise.track.slug,
            language: solution.exercise.track.title
          }
        },
        file_download_base_url: "https://test.exercism.io/api/v1/solutions/#{solution.uuid}/files/",
        files: Set.new([]),
        iteration: nil
      }
    }

    assert_equal expected, responder.to_hash
  end

  test "to_hash with different requester" do
    user = create :user
    solution = create :solution
    user_track = create :user_track, user: solution.user, track: solution.exercise.track

    responder = API::SolutionResponder.new(solution, user)
    refute responder.to_hash[:solution][:user][:is_requester]
  end

  test "handle is alias on anonymous track" do
    handle = "foosa1111"
    user = create :user
    track = create :track
    create :user_track, user: user, track: track, anonymous: true, handle: handle
    solution = create :solution, user: user, exercise: create(:exercise, track: track)

    responder = API::SolutionResponder.new(solution, user)
    assert_equal handle, responder.to_hash[:solution][:user][:handle]
  end

  test "iteration is represented correctly" do
    solution = create :solution
    user_track = create :user_track, user: solution.user, track: solution.exercise.track
    responder = API::SolutionResponder.new(solution, solution.user)

    created_at = Time.now.getutc - 1.week
    iteration = create :iteration, solution: solution, created_at: created_at
    assert_equal created_at.to_i, responder.to_hash[:solution][:iteration][:submitted_at].to_i
  end

  test "solution_url should be /mentor/solutions if mentor" do
    solution = create :solution
    user_track = create :user_track, user: solution.user, track: solution.exercise.track
    mentor = create :user
    create :track_mentorship, user: mentor, track: solution.exercise.track
    responder = API::SolutionResponder.new(solution, mentor)
    assert_equal "https://test.exercism.io/mentor/solutions/#{solution.uuid}", responder.to_hash[:solution][:url]
  end

  test "instructions_url should be /my/solutions for solution user if published" do
    solution = create :solution, published_at: DateTime.now - 1.week
    track = solution.exercise.track
    user_track = create :user_track, user: solution.user, track: track
    responder = API::SolutionResponder.new(solution, solution.user)
    assert_equal "https://test.exercism.io/my/solutions/#{solution.uuid}", responder.to_hash[:solution][:url]
  end

  test "instructions_url should be /solutions for other user if published" do
    solution = create :solution, published_at: DateTime.now - 1.week
    track = solution.exercise.track
    user_track = create :user_track, user: solution.user, track: track
    responder = API::SolutionResponder.new(solution, create(:user))
    assert_equal "https://test.exercism.io/tracks/#{track.slug}/exercises/#{solution.exercise.slug}/solutions/#{solution.uuid}", responder.to_hash[:solution][:url]
  end

  test "instructions_url should be /solutions if mentor and published" do
    solution = create :solution, published_at: DateTime.now - 1.week
    track = solution.exercise.track
    user_track = create :user_track, user: solution.user, track: solution.exercise.track
    mentor = create :user
    create :track_mentorship, user: mentor, track: solution.exercise.track
    responder = API::SolutionResponder.new(solution, mentor)
    assert_equal "https://test.exercism.io/tracks/#{track.slug}/exercises/#{solution.exercise.slug}/solutions/#{solution.uuid}", responder.to_hash[:solution][:url]
  end

  test "files honours ignore_regexp" do
    track = create :track
    exercise = create :exercise, track: track
    solution = create :solution
    file_1 = "foobar.js"
    file_2 = "barfoo.go"
    file_3 = "some_example.json"
    user_track = create :user_track, user: solution.user, track: solution.exercise.track

    responder = API::SolutionResponder.new(solution, solution.user)
    @mock_exercise.expects(:files).returns([file_1, file_2, file_3])
    expected = Set.new([file_1, file_2])
    assert_equal expected, responder.to_hash[:solution][:files]
  end

  test "files includes solution files" do
    solution = create :solution
    iteration = create :iteration, solution: solution
    exercise_filepath_1 = "foobar.js"
    exercise_filepath_2 = "barfoo.go"
    file1 = create :iteration_file, iteration: iteration
    file2 = create :iteration_file, iteration: iteration
    file3 = create :iteration_file, iteration: iteration, filename: exercise_filepath_2
    user_track = create :user_track, user: solution.user, track: solution.exercise.track

    responder = API::SolutionResponder.new(solution, solution.user)
    @mock_exercise.expects(:files).returns([exercise_filepath_1, exercise_filepath_2])
    expected = Set.new([exercise_filepath_1, exercise_filepath_2, file1.filename, file2.filename])
    assert_equal expected, responder.to_hash[:solution][:files]
  end

  test "honours auto_approve true" do
    exercise = create :exercise, auto_approve: true
    solution = create :solution, exercise: exercise
    user_track = create :user_track, user: solution.user, track: solution.exercise.track
    responder = API::SolutionResponder.new(solution, solution.user)
    assert responder.to_hash[:solution][:exercise][:auto_approve]
  end

  test "to_hash with team_solution" do
    user = create :user
    solution = create :team_solution

    responder = API::SolutionResponder.new(solution, user)
    assert_equal solution.user.handle, responder.to_hash[:solution][:user][:handle]

    team_json = {
      name: solution.team.name,
      slug: solution.team.slug
    }
    assert_equal team_json, responder.to_hash[:solution][:team]
  end

end
