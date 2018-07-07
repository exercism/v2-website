require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "unlocking track" do
    user = create :user
    track = create :track
    refute user.joined_track?(track)

    create :user_track, user: user, track: track
    assert user.joined_track?(track)
  end

  test "previously joined track" do
    user = create(:user)
    previously_joined = create(:track)
    currently_joined = create(:track)
    create(:user_track,
           user: user,
           track: previously_joined,
           archived_at: Date.new(2016, 12, 25))
    create(:user_track, track: currently_joined, user: user, archived_at: nil)

    assert user.previously_joined_track?(previously_joined)
    refute user.previously_joined_track?(currently_joined)
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
    solution = create :solution, published_at: nil
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

  test "may_view_solution? for team_solution and random user" do
    solution = create :team_solution
    user = create :user
    refute user.may_view_solution?(solution)
  end

  test "may_view_solution? for team_solution and solution_user" do
    solution = create :team_solution
    assert solution.user.may_view_solution?(solution)
  end

  test "may_view_solution? for team_solution and team member" do
    team = create :team
    solution = create :team_solution, team: team

    user = create :user
    create :team_membership, user: user, team: team
    assert user.may_view_solution?(solution)
  end

  test "handle is valid" do
    user = build :user

    assert ((user.handle = "foo") and user.valid?)
    assert ((user.handle = "123foo321") and user.valid?)
    assert ((user.handle = "1-23foo32-1") and user.valid?)

    refute ((user.handle = "") and user.valid?)
    refute ((user.handle = "_23foo32") and user.valid?)
    refute ((user.handle = "foo'bar") and user.valid?)
  end

  test "test_user?" do
    user = build :user
    refute user.test_user?

    user.email = nil
    refute user.test_user?

    user.email = "humpty.dumpty+testexercismuser1@example.com"
    assert user.test_user?

    user.email = "humpty.dumpty+TESTEXERCISMUSER2@example.com"
    assert user.test_user?
  end

  test "may_unlock_user?" do
    user = create :user
    track = create :track
    user_track = create :user_track, user: user, track: track
    core_exercise = create :exercise, track: track, core: true
    side_exercise_with_unlock = create :exercise, track: track, core: false, unlocked_by: core_exercise
    side_exercise_without_unlock = create :exercise, track: track, core: false

    refute user.may_unlock_exercise?(user_track, core_exercise)
    refute user.may_unlock_exercise?(user_track, side_exercise_with_unlock)
    assert user.may_unlock_exercise?(user_track, side_exercise_without_unlock)

    user_track.update(independent_mode: true)
    assert user.may_unlock_exercise?(user_track, core_exercise)
    assert user.may_unlock_exercise?(user_track, side_exercise_with_unlock)
    assert user.may_unlock_exercise?(user_track, side_exercise_without_unlock)
  end

  test "destroying a user preserves discussions as a mentor and deletes discussions as a learner" do
    user = create(:user)
    mentor_post = create(:discussion_post, user: user)
    solution = create(:solution, user: user)
    iteration = create(:iteration, solution: solution)
    learner_post = create(:discussion_post, iteration: iteration, user: user)

    user.destroy

    refute DiscussionPost.exists?(learner_post.id)
    mentor_post.reload
    refute mentor_post.destroyed?
    assert_nil mentor_post.user
  end

  test "onboarded?" do
    not_onboarded_1 = create :user, accepted_terms_at: nil, accepted_privacy_policy_at: nil
    not_onboarded_2 = create :user, accepted_terms_at: DateTime.now - 1.day, accepted_privacy_policy_at: nil
    not_onboarded_3 = create :user, accepted_terms_at: nil, accepted_privacy_policy_at: DateTime.now - 1.day
    onboarded = create :user, accepted_terms_at: DateTime.now - 1.day, accepted_privacy_policy_at: DateTime.now - 1.day

    assert onboarded.onboarded?
    refute not_onboarded_1.onboarded?
    refute not_onboarded_2.onboarded?
    refute not_onboarded_3.onboarded?
  end
end
