require "test_helper"

class FixUnlockingInUserTrackTest < ActiveSupport::TestCase
  test "works for an empty user_track" do
    git_sha = SecureRandom.uuid
    Git::ExercismRepo.stubs(current_head: git_sha)

    user = create :user
    track = create :track
    user_track = create :user_track, user: user, track: track

    assert_nothing_raised do
      FixUnlockingInUserTrack.(user_track)
    end
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
    bonus1 = create :exercise, track: track
    bonus2 = create :exercise, track: track

    # A solution that's got a iteration
    # This should be persisted
    c3s1_sol = create :solution, exercise: c3s1, user: user
    create :iteration, solution: c3s1_sol

    # A completed core
    # This should be persisted
    c1_sol = create :solution, exercise: c1, approved_by: create(:user), completed_at: Time.now - 1.day, user: user
    create :iteration, solution: c1_sol

    # An unlocked side
    # This should be persisted
    c1s2_sol = create :solution, exercise: c1s2, user: user

    # A different unlocked side that shouldn't be unlocked
    # This should not be persisted as it's not been started and it shouldn't be unlocked
    c2s1_sol = create :solution, exercise: c2s1, user: user

    # A bonus exercise. This one should be maintained
    # but one shouldn't be created for bonus2, as that can be
    # unlocked on demand within the UI.
    bonus1_sol = create :solution, exercise: bonus1, user: user

    # This should get ignored and deleted
    # and replaced with c2
    c3_sol = create :solution, exercise: c3, user: user

    user_track = create :user_track, user: user, track: track
    FixUnlockingInUserTrack.(user_track)

    actual = user_track.solutions
    assert actual.include?(c1_sol)
    assert actual.include?(c1s2_sol)
    assert actual.include?(c3s1_sol)
    assert actual.include?(bonus1_sol)

    expected_exercises = [ c1, c2, c1s1, c1s2, c3s1, bonus1 ].map(&:id).sort
    assert_equal expected_exercises, user_track.solutions.map(&:exercise_id).sort
    #p Benchmark.measure { 1000.times { FixUnlockingInUserTrack.(user_track) } }.real
  end
end
