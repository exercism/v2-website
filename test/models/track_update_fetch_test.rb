require 'test_helper'

class TrackUpdateFetchTest < ActiveSupport::TestCase
  test "validates presence of track update" do
    track_update_fetch = build(:track_update_fetch, track_update: nil)
    refute track_update_fetch.valid?

    track_update_fetch = build(:track_update_fetch, track_update: build(:track_update))
    assert track_update_fetch.valid?
  end

  test "validates presence of host" do
    track_update_fetch = build(:track_update_fetch, host: nil)
    refute track_update_fetch.valid?

    track_update_fetch = build(:track_update_fetch, host: "host-1")
    assert track_update_fetch.valid?
  end
end
