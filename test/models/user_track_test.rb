require 'test_helper'

class UserTrackTest < ActiveSupport::TestCase
  test "record can be saved without a handle" do
    create :user_track, handle: nil
  end

  test "record can be updated without handle blowing up" do
    user_track = create :user_track, handle: "foobar"
    user_track.track = create(:track)
    user_track.save!
  end

  test "handle must be unique across user_tracks" do
    handle = SecureRandom.uuid
    create :user_track, handle: handle
    ut = build :user_track, handle: handle
    refute ut.valid?
    assert ut.errors.keys.include?(:handle)
  end

  test "handle must be unique across users" do
    handle = SecureRandom.uuid
    create :user, handle: handle
    ut = build :user_track, handle: handle
    refute ut.valid?
    assert ut.errors.keys.include?(:handle)
  end

  test "originated_in_v1" do
    old = create :user_track, created_at: Exercism::V2_MIGRATED_AT - 1.minute
    new = create :user_track, created_at: Exercism::V2_MIGRATED_AT + 1.minute

    assert old.originated_in_v1?
    refute new.originated_in_v1?
  end

  test "archived?" do
    archived = build(:user_track, archived_at: Date.new(2016, 12, 25))
    unarchived = build(:user_track, archived_at: nil)

    assert archived.archived?
    refute unarchived.archived?
  end

  test "unarchived user tracks" do
    archived = create(:user_track, archived_at: Date.new(2016, 12, 25))
    unarchived = create(:user_track, archived_at: nil)

    assert_equal [unarchived], UserTrack.unarchived
  end

  test "archived user tracks" do
    archived = create(:user_track, archived_at: Date.new(2016, 12, 25))
    unarchived = create(:user_track, archived_at: nil)

    assert_equal [archived], UserTrack.archived
  end

  test "solutions being mentored for independent_mode" do
    user = create :user
    track = create :track
    user_track = create :user_track, user: user, track: track, independent_mode: true

    assert_equal 1, user_track.mentoring_slots_remaining
    assert user_track.mentoring_slots_remaining
    refute user_track.mentoring_allowance_used_up?

    s1 = create :solution, mentoring_requested_at: nil, user: user, exercise: create(:exercise, track: track)
         create :iteration, solution: s1

    s2 = create :solution, mentoring_requested_at: nil, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)
         create :iteration, solution: s2

    s3 = create :solution, mentoring_requested_at: Time.current, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)
         create :iteration, solution: s3

    s4 = create :solution, mentoring_requested_at: Time.current, user: user, exercise: create(:exercise, track: track)

    s5 = create :solution, mentoring_requested_at: Time.current, user: user, exercise: create(:exercise, track: track)
         create :iteration, solution: s5

    assert_equal [s5], user_track.solutions_using_mentoring_allowance
    assert_equal 0, user_track.mentoring_slots_remaining
    refute user_track.mentoring_slots_remaining?
    assert user_track.mentoring_allowance_used_up?
  end

  test "solutions being mentored for mentored_mode" do
    user = create :user
    track = create :track
    user_track = create :user_track, user: user, track: track, independent_mode: false

    assert_equal 3, user_track.mentoring_slots_remaining
    assert user_track.mentoring_slots_remaining
    refute user_track.mentoring_allowance_used_up?

    s1 = create :solution, mentoring_requested_at: nil, user: user, exercise: create(:exercise, track: track)
         create :iteration, solution: s1

    s2 = create :solution, mentoring_requested_at: nil, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)
         create :iteration, solution: s2

    s3 = create :solution, mentoring_requested_at: Time.current, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)
         create :iteration, solution: s3

    s4 = create :solution, mentoring_requested_at: Time.current, user: user, exercise: create(:exercise, track: track)

    s5 = create :solution, mentoring_requested_at: Time.current, user: user, exercise: create(:exercise, track: track, core: true)
         create :iteration, solution: s5

    s6 = create :solution, mentoring_requested_at: Time.current, user: user, exercise: create(:exercise, track: track, core: false)
         create :iteration, solution: s6

    assert_equal [s6], user_track.solutions_using_mentoring_allowance
    assert_equal 2, user_track.mentoring_slots_remaining

    2.times do
      create :iteration, solution: create(:solution, mentoring_requested_at: Time.current, user: user, exercise: create(:exercise, track: track, core: false))
    end

    assert_equal 0, user_track.mentoring_slots_remaining
    refute user_track.mentoring_slots_remaining?
    assert user_track.mentoring_allowance_used_up?
  end

  test "counters in mentored mode" do
    track = create :track
    core1 = create :exercise, track: track, core: true
    core2 = create :exercise, track: track, core: true
    core3 = create :exercise, track: track, core: true
    side1 = create :exercise, track: track, core: false, unlocked_by: core1
    side2 = create :exercise, track: track, core: false, unlocked_by: core2
    side3 = create :exercise, track: track, core: false
    side4 = create :exercise, track: track, core: false
    side5 = create :exercise, track: track, core: false, unlocked_by: core2
    side6 = create :exercise, track: track, core: false, unlocked_by: core3

    create :exercise, track: track, core: true, active: false
    create :exercise, track: track, core: false, active: false

    user = create :user
    c1s = create :solution, exercise: core1, user: user, completed_at: Time.now
    s2s = create :solution, exercise: side2, user: user, completed_at: Time.now
    s4s = create :solution, exercise: side4, user: user, completed_at: Time.now
    c2s = create :solution, exercise: core2, user: user

    user_track = create :user_track, user: user, track: track, independent_mode: false
    assert_equal 1, user_track.num_completed_core_exercises
    assert_equal 2, user_track.num_completed_side_exercises
    assert_equal 1, user_track.num_avaliable_core_exercises
    assert_equal 2, user_track.num_avaliable_side_exercises
  end

  test "counters in independent mode" do
    track = create :track
    core1 = create :exercise, track: track, core: true
    core2 = create :exercise, track: track, core: true
    core3 = create :exercise, track: track, core: true
    side1 = create :exercise, track: track, core: false, unlocked_by: core1
    side2 = create :exercise, track: track, core: false, unlocked_by: core2
    side3 = create :exercise, track: track, core: false
    side4 = create :exercise, track: track, core: false
    side5 = create :exercise, track: track, core: false, unlocked_by: core2
    side6 = create :exercise, track: track, core: false, unlocked_by: core3

    create :exercise, track: track, core: true, active: false
    create :exercise, track: track, core: false, active: false

    user = create :user
    c1s = create :solution, exercise: core1, user: user, completed_at: Time.now
    s2s = create :solution, exercise: side2, user: user, completed_at: Time.now
    s4s = create :solution, exercise: side4, user: user, completed_at: Time.now
    c2s = create :solution, exercise: core2, user: user

    user_track = create :user_track, user: user, track: track, independent_mode: true
    assert_equal 1, user_track.num_completed_core_exercises
    assert_equal 2, user_track.num_completed_side_exercises
    assert_equal 2, user_track.num_avaliable_core_exercises
    assert_equal 4, user_track.num_avaliable_side_exercises
  end
end
