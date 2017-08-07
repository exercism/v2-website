require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "unlocking track" do
    user = create :user
    track = create :track
    refute user.joined_track?(track)

    create :user_track, user: user, track: track
    assert user.joined_track?(track)
  end

  test "mentor?" do
    user = create :user
    refute user.mentor?

    create :track_mentorship, user: user
    user.reload
    assert user.mentor?
  end

  test "record cannot be saved without a handle" do
    user = build :user, handle: nil
    refute user.valid?
    assert user.errors.keys.include?(:handle)
  end

  test "record can be updated without handle blowing up" do
    user = create :user, handle: "foobar"
    user.name = "Foobar!"
    user.save!
  end

  test "handle must be unique across user_tracks" do
    handle = SecureRandom.uuid
    create :user_track, handle: handle
    user = build :user, handle: handle
    refute user.valid?
    assert user.errors.keys.include?(:handle)
  end

  test "handle must be unique across users" do
    handle = SecureRandom.uuid
    create :user, handle: handle
    u = build :user, handle: handle
    refute u.valid?
    assert u.errors.keys.include?(:handle)
  end

  test "may_view_solution? for random user" do
    solution = create :solution, published_at: DateTime.now - 1.week
    user = create :user
    refute user.may_view_solution?(solution)
  end

  test "may_view_solution? for solution_user" do
    solution = create :solution
    assert solution.user.may_view_solution?(solution)
  end

  test "may_view_solution? for published solution" do
    solution = create :solution, published_at: DateTime.now - 1.week
    user = create :user
    assert user.may_view_solution?(solution)
  end

  test "may_view_solution? for mentor" do
    solution = create :solution, published_at: DateTime.now - 1.week
    user = create :user
    create :track_mentorship, track: solution.exercise.track, user: user
    assert user.may_view_solution?(solution)
  end
end
