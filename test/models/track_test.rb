require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test "accepting_new_students?" do
    # Under 1 week
    track = create :track, median_wait_time: 604799
    assert track.accepting_new_students?

    # Over 1 week
    track = create :track, median_wait_time: 604801
    refute track.accepting_new_students?

    # Nothing recently mentored - works off queue size
    track = create :track, median_wait_time: nil
    assert track.accepting_new_students?

    create_solution = Proc.new {
      s = create :solution,
        user: create(:user, current_sign_in_at: Time.now),
        exercise: create(:exercise, track: track, core: true),
        mentoring_requested_at: Time.now - 1.week
      create :iteration, solution: s
    }

    # Up to 10 solutions it should be fine
    9.times { create_solution.call }
    assert track.accepting_new_students?

    # But at 10 it stops accepting
    create_solution.call
    refute track.accepting_new_students?
  end

  test "research_track?" do
    refute create(:track, slug: "ruby").research_track?
    assert create(:track, slug: "research_123").research_track?
  end
end
