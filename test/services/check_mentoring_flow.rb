require 'test_helper'

class CheckMentoringFlowTest < ActiveSupport::TestCase
  setup do
    code = "foobar"
    filename = "dog/foobar.rb"
    file_contents = "something = :else"
    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename}\"\r\nContent-Type: application/octet-stream\r\n"
    @file = mock
    @file.stubs(read: file_contents, headers: headers)
  end

  test "core exercise gets mentoring requested" do
    Git::ExercismRepo.stubs(current_head: SecureRandom.uuid)

    user = create :user
    track = create :track
    create :user_track, user: user, track: track, independent_mode: false

    exercise = create :exercise, track: track, core: true

    solution = CreateSolution.(user, exercise)
    CreateIteration.(solution, [@file])

    solution.reload
    assert solution.mentoring_requested?
  end

  test "side exercise does not gets mentoring requested" do
    Git::ExercismRepo.stubs(current_head: SecureRandom.uuid)

    user = create :user
    track = create :track
    create :user_track, user: user, track: track, independent_mode: false

    exercise = create :exercise, track: track, core: false

    solution = CreateSolution.(user, exercise)
    CreateIteration.(solution, [@file])

    solution.reload
    refute solution.mentoring_requested?
  end

  test "independent core exercise does not gets mentoring requested" do
    Git::ExercismRepo.stubs(current_head: SecureRandom.uuid)

    user = create :user
    track = create :track
    create :user_track, user: user, track: track, independent_mode: true

    exercise = create :exercise, track: track, core: true

    solution = CreateSolution.(user, exercise)
    CreateIteration.(solution, [@file])

    solution.reload
    refute solution.mentoring_requested?
  end
end
