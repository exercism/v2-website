require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test "accepting_new_students?" do
    create_solution = ->(track) do
      s = create :solution,
        user: create(:user, current_sign_in_at: Time.now),
        exercise: create(:exercise, track: track, core: true),
        mentoring_requested_at: Time.now - 1.week
      create :iteration, solution: s
    end

    # If a track has <10 solutions, always return true
    track = create :track, median_wait_time: 2.years
    9.times { create_solution.call(track) }

    # Under 1 week
    track = create :track, median_wait_time: 604799
    10.times { create_solution.call(track) }
    assert track.accepting_new_students?

    # Over 1 week
    track = create :track, median_wait_time: 604801
    10.times { create_solution.call(track) }
    refute track.accepting_new_students?
  end

  test "research_track?" do
    refute create(:track, slug: "ruby").research_track?
    assert create(:track, slug: "research_123").research_track?
  end
end
