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

  test "solutions_being_mentored" do
    user = create :user
    track = create :track
    user_track = create :user_track, user: user, track: track

    assert_equal 0, user_track.num_solutions_being_mentored
    assert_equal 1, user_track.mentoring_slots_remaining
    assert user_track.mentoring_slots_remaining

    s1 = create :solution, independent_mode: true, mentoring_enabled: true, user: user, exercise: create(:exercise, track: track)
         create :solution, independent_mode: true, mentoring_enabled: true, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)
         create :solution, independent_mode: true, mentoring_enabled: false, user: user, exercise: create(:exercise, track: track)
         create :solution, independent_mode: true, mentoring_enabled: false, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)
    s2 = create :solution, independent_mode: false, mentoring_enabled: true, user: user, exercise: create(:exercise, track: track)
         create :solution, independent_mode: false, mentoring_enabled: true, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)
    s3 = create :solution, independent_mode: false, mentoring_enabled: false, user: user, exercise: create(:exercise, track: track)
         create :solution, independent_mode: false, mentoring_enabled: false, approved_by: create(:user), user: user, exercise: create(:exercise, track: track)

    expected = [s1,s2,s3].sort.map(&:id)
    assert_equal expected, user_track.solutions_being_mentored.sort.map(&:id)
    assert_equal 3, user_track.num_solutions_being_mentored
    assert_equal -2, user_track.mentoring_slots_remaining
    refute user_track.mentoring_slots_remaining?
  end

end
