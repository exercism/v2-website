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
end
