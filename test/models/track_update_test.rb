require 'test_helper'

class TrackUpdateTest < ActiveSupport::TestCase
  test "validates presence of track" do
    track_update = build(:track_update, track: nil)
    refute track_update.valid?

    track_update = build(:track_update, track: build(:track))
    assert track_update.valid?
  end
end
