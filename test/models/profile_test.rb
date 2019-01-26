require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test "correct solutions are returned" do
    user = create :user
    profile = create :profile, user: user

    good_user_track = create :user_track, anonymous: false, user: user
    bad_user_track = create :user_track, anonymous: true, user: user

    good_exercise_1 = create :exercise, track: good_user_track.track
    good_exercise_2 = create :exercise, track: good_user_track.track
    good_exercise_3 = create :exercise, track: good_user_track.track
    bad_exercise = create :exercise, track: bad_user_track.track

    create :solution, published_at: nil, user: user
    create :solution, published_at: DateTime.now, exercise: bad_exercise, user: user
    s1 = create :solution, published_at: DateTime.now, exercise: good_exercise_1, user: user, num_stars: 2
    s2 = create :solution, published_at: DateTime.now, exercise: good_exercise_2, user: user, num_stars: 1
    s3 = create :solution, published_at: DateTime.now, exercise: good_exercise_3, user: user, num_stars: 3

    assert_equal [s3,s1,s2], profile.solutions
  end
end
