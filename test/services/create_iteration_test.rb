require 'test_helper'

class CreateIterationTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    solution = create :solution
    code = "foobar"
    filename = "dog/foobar.rb"
    file_contents = "something = :else"
    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename}\"\r\nContent-Type: application/octet-stream\r\n"
    file = mock(read: file_contents, headers: headers)

    iteration = CreateIteration.(solution, [file])

    assert iteration.persisted?
    assert_equal iteration.solution, solution
    assert_equal 1, iteration.files.count

    saved_file = iteration.files.first
    assert_equal filename, saved_file.filename
    assert_equal file_contents, saved_file.file_contents
  end

  test "unlocks one side exercise" do
    Timecop.freeze do
      core_exercise = create :exercise, core: true, position: 1
      side_exercise1 = create :exercise, core: false, unlocked_by: core_exercise
      side_exercise2 = create :exercise, core: false, unlocked_by: core_exercise

      solution = create :solution, exercise: core_exercise
      CreateSolution.expects(:call).once.with(solution.user, side_exercise1)
      CreateIteration.(solution, [])
    end
  end

  test "does not unlock side exercise if there is only 1" do
    Timecop.freeze do
      core_exercise = create :exercise, core: true, position: 1
      side_exercise = create :exercise, core: false, unlocked_by: core_exercise

      solution = create :solution, exercise: core_exercise
      CreateSolution.expects(:call).never
      CreateIteration.(solution, [])
    end
  end

  test "does not unlock side exercise if there already is one" do
    Timecop.freeze do
      core_exercise = create :exercise, core: true, position: 1
      side_exercise1 = create :exercise, core: false, unlocked_by: core_exercise
      side_exercise2 = create :exercise, core: false, unlocked_by: core_exercise

      user = create :user
      create :solution, user: user, exercise: side_exercise1
      solution = create :solution, user: user, exercise: core_exercise
      CreateSolution.expects(:call).never
      CreateIteration.(solution, [])
    end
  end

  test "updates last updated by" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      assert_nil solution.last_updated_by_user_at

      CreateIteration.(solution, [])
      assert_equal DateTime.now.to_i, solution.last_updated_by_user_at.to_i
    end
  end

  test "set all mentors' requires_action to true" do
    solution = create :solution
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: solution, requires_action: false

    CreateIteration.(solution, [])

    mentorship.reload
    assert mentorship.requires_action
  end

  test "does not set mentor status if approved" do
    solution = create :solution, approved_by: create(:user)
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: solution, requires_action: false

    CreateIteration.(solution, [])

    mentorship.reload
    refute mentorship.requires_action
  end

  test "does not notify non-current mentors" do
    solution = create :solution
    user = solution.user

    # Create a user who mentored this solution but doesn't
    # have a current track mentorship so is inactive.
    inactive_mentor = create :user
    create :solution_mentorship, solution: solution, user: inactive_mentor

    CreateNotification.expects(:call).never
    DeliverEmail.expects(:call).never
    CreateIteration.(solution, [])
  end

  test "notifies and emails mentors" do
    solution = create :solution
    user = solution.user

    # Setup mentors
    mentor1 = create :user
    mentor2 = create :user
    create :track_mentorship, user: mentor1
    create :track_mentorship, user: mentor2
    create :solution_mentorship, solution: solution, user: mentor1
    create :solution_mentorship, solution: solution, user: mentor2

    CreateNotification.expects(:call).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_iteration_for_mentor, args[1]
      assert_equal "<strong>#{user.handle}</strong> has posted a new iteration on a solution you are mentoring", args[2]
      assert_equal "https://test.exercism.io/mentor/solutions/#{solution.uuid}", args[3]
      assert_equal solution, args[4][:about]
    end

    DeliverEmail.expects(:call).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_iteration_for_mentor, args[1]
      assert_equal Iteration, args[2].class
    end

    CreateIteration.(solution, [])
  end

  test "auto approve when auto_approve is set" do
    exercise = create :exercise, auto_approve: true
    solution = create :solution, exercise: exercise

    CreateIteration.(solution, [])

    solution.reload
    assert solution.user, solution.approved_by
  end

  test "sends a notification when a solution is auto approved" do
    exercise = create :exercise, auto_approve: true
    solution = create :solution, exercise: exercise

    CreateNotification.
      expects(:call).
      with(solution.user,
           :exercise_auto_approved,
           "Your solution to <strong>#{solution.exercise.title}</strong> on the "\
           "<strong>#{solution.exercise.track.title}</strong> track has been "\
           "auto approved.",
            Rails.application.routes.url_helpers.my_solution_url(solution),
            about: solution)

    CreateIteration.(solution, [])
  end

  test "works for not-duplicate files" do
    filename1 = "foobar"
    filename2 = "barfoo"
    file_contents1 = "foobar123"
    file_contents2 = "barfoo123"
    solution = create :solution
    iteration = create :iteration, solution: solution
    create :iteration_file, iteration: iteration, filename: filename1, file_contents: file_contents1
    create :iteration_file, iteration: iteration, filename: filename2, file_contents: file_contents2

    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename1}\"\r\nContent-Type: application/octet-stream\r\n"
    file1 = mock(read: file_contents1, headers: headers)
    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename2}\"\r\nContent-Type: application/octet-stream\r\n"
    file2 = mock(read: (file_contents2 + "456"), headers: headers)

    iteration = CreateIteration.(solution, [file1, file2])
    assert iteration.persisted?
    assert_equal 2, iteration.files.count
  end

  test "raises for duplicate files" do
    filename1 = "foobar"
    filename2 = "barfoo"
    file_contents1 = "foobar123"
    file_contents2 = "barfoo123"
    solution = create :solution
    iteration = create :iteration, solution: solution
    create :iteration_file, iteration: iteration, filename: filename1, file_contents: file_contents1
    create :iteration_file, iteration: iteration, filename: filename2, file_contents: file_contents2

    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename1}\"\r\nContent-Type: application/octet-stream\r\n"
    file1 = mock(read: file_contents1, headers: headers)
    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename2}\"\r\nContent-Type: application/octet-stream\r\n"
    file2 = mock(read: file_contents2, headers: headers)

    assert_raises do
      CreateIteration.(solution, [file1, file2])
    end
  end

  test "sets flags for team solution" do
    solution = create :team_solution, needs_feedback: false, has_unseen_feedback: true
    code = "foobar"
    filename = "dog/foobar.rb"
    file_contents = "something = :else"
    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename}\"\r\nContent-Type: application/octet-stream\r\n"
    file = mock(read: file_contents, headers: headers)

    iteration = CreateIteration.(solution, [file])

    assert iteration.persisted?
    assert_equal iteration.solution, solution
    assert_equal 1, iteration.files.count

    saved_file = iteration.files.first
    assert_equal filename, saved_file.filename
    assert_equal file_contents, saved_file.file_contents

    solution.reload
    assert solution.needs_feedback
    refute solution.has_unseen_feedback
    assert_equal 1, solution.num_iterations
  end

  test "sets mentoring_requested_at correctly" do
    code = "foobar"
    filename = "dog/foobar.rb"
    file_contents = "something = :else"
    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename}\"\r\nContent-Type: application/octet-stream\r\n"
    file = mock
    file.stubs(read: file_contents, headers: headers)


    ruby = create :track
    core_exercise = create :exercise, track: ruby, core: true
    side_exercise = create :exercise, track: ruby, core: false

    normal_user = create :user
    independent_user = create :user

    core_solution = create :solution, user: normal_user, exercise: core_exercise, track_in_independent_mode: false
    side_solution = create :solution, user: normal_user, exercise: side_exercise, track_in_independent_mode: false
    independent_solution = create :solution, user: independent_user, exercise: core_exercise, track_in_independent_mode: true

    CreateIteration.(core_solution, [file])
    CreateIteration.(side_solution, [file])
    CreateIteration.(independent_solution, [file])

    [core_solution, side_solution,independent_solution].each(&:reload)

    assert core_solution.mentoring_requested?
    refute side_solution.mentoring_requested?
    refute independent_solution.mentoring_requested?
  end
end
