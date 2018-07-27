require 'test_helper'

class SwitchTrackToMentoredModeTest < ActiveSupport::TestCase
  test "sets uncompleted solutions to independent mode" do
    user = create :user
    track = create :track
    completed_solution = create :solution, user: user, exercise: create(:exercise, track: track), independent_mode: true, completed_at: DateTime.now, track_in_independent_mode: true
    uncompleted_solution = create :solution, user: user, exercise: create(:exercise, track: track), independent_mode: true, completed_at: nil, track_in_independent_mode: true
    create :iteration, solution: completed_solution
    create :iteration, solution: uncompleted_solution
    user_track = create :user_track, user: user, track: track

    SwitchTrackToMentoredMode.(user, track)

    [user_track, completed_solution, uncompleted_solution].each(&:reload)

    refute user_track.independent_mode?
    assert completed_solution.independent_mode
    refute uncompleted_solution.independent_mode

    refute completed_solution.track_in_independent_mode
    refute uncompleted_solution.track_in_independent_mode
  end

  test "correct exercises get deleted and unlocked" do
    git_sha = SecureRandom.uuid
    Git::ExercismRepo.stubs(current_head: git_sha)

    user = create :user
    track = create :track
    c3 = create :exercise, track: track, core: true, position: 3
    c2 = create :exercise, track: track, core: true, position: 2
    c1 = create :exercise, track: track, core: true, position: 1
    c1s1 = create :exercise, track: track, unlocked_by: c1
    c1s2 = create :exercise, track: track, unlocked_by: c1
    c2s1 = create :exercise, track: track, unlocked_by: c2
    c3s1 = create :exercise, track: track, unlocked_by: c3
    bonus = create :exercise, track: track

    # A solution that's got a iteration
    c3s1_sol = create :solution, exercise: c3s1, independent_mode: true, user: user
    create :iteration, solution: c3s1_sol

    # A completed core
    c1_sol = create :solution, exercise: c1, approved_by: create(:user), completed_at: Time.now - 1.day, independent_mode: true, user: user
    create :iteration, solution: c1_sol

    # An unlocked side
    c1s2_sol = create :solution, exercise: c1s2, independent_mode: true, user: user

    # A different unlocked side that shouldn't be unlocked
    c2s1_sol = create :solution, exercise: c2s1, independent_mode: true, user: user

    user_track = create :user_track, user: user, track: track

    SwitchTrackToMentoredMode.(user, track)

    actual = user_track.solutions
    actual.include?(c1_sol)
    actual.include?(c3s1_sol)

    expected_exercises = [ c1, c2, c1s1, c1s2, c3s1 ].map(&:id).sort
    assert_equal expected_exercises, user_track.solutions.map(&:exercise_id).sort
  end
end
