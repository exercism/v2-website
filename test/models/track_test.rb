require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test "accepting_new_students?" do
    track = build :track

    track.median_wait_time = nil
    refute track.accepting_new_students?

    # Under 1 week
    track.median_wait_time = 604799
    assert track.accepting_new_students?

    # Over 1 week
    track.median_wait_time = 604801
    refute track.accepting_new_students?
  end

  test "research_track?" do
    refute create(:track, slug: "ruby").research_track?
    assert create(:track, slug: "research_123").research_track?
  end
end
