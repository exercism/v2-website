require 'test_helper'

class Git::StateDbTest < ActiveSupport::TestCase
  def setup
    @track = create :track
    @track_2 = create :track
    @track_3 = create :track

    @db = Git::StateDb.new("/tmp/exercism-test-git-state-db-#{SecureRandom.uuid}", 60.seconds)
  end

  test "returns default sync-state values for new track" do
    state = @db.sync_state_for(@track)
    refute state.nil?
    assert state[:last_sync].nil?
    assert state[:status].nil?
  end

  test "sets sync-state values for succesful sync" do
    @db.mark_synced(@track)

    state = @db.sync_state_for(@track)
    refute state.nil?
    refute state[:last_sync].nil?
    assert_equal true, state[:success]
  end

  test "sets sync-state values for failed sync" do
    @db.mark_failed(@track)

    state = @db.sync_state_for(@track)
    refute state.nil?
    refute state[:last_sync].nil?
    assert_equal false, state[:success]
  end

  test "fetches stale tracks" do
    ts1 = 3.minutes.ago
    ts2 = 1.minutes.ago
    dummy_now = DateTime.now

    Timecop.freeze(ts1)
    @db.mark_synced(@track)

    Timecop.freeze(ts2)
    @db.mark_synced(@track_2)

    Timecop.freeze(dummy_now)
    assert_equal 0, @db.stale_tracks_before(10.minutes).size
    assert_equal 1, @db.stale_tracks_before(2.minutes).size
    assert_equal 2, @db.stale_tracks_before(10.seconds).size

    stale_track = @db.stale_tracks_before(2.minutes).first
    assert_equal @track.id, stale_track[:track_id]
  end

  test "fetches stale tracks, oldest first" do
    dummy_now = DateTime.now

    Timecop.freeze(3.minutes.ago)
    @db.mark_synced(@track)

    Timecop.freeze(2.minutes.ago)
    @db.mark_synced(@track_2)

    Timecop.freeze(1.minutes.ago)
    @db.mark_synced(@track_3)

    Timecop.freeze(1.minutes.ago)
    @db.mark_synced(@track)

    Timecop.freeze(dummy_now)
    stale_tracks = @db.stale_tracks_before(2.seconds)
    assert_equal @track_2.id, stale_tracks.first[:track_id]
    assert_equal @track_3.id, stale_tracks.second[:track_id]
    assert_equal @track.id, stale_tracks.third[:track_id]
  end

  test "fetches stale tracks, failures last" do
    dummy_now = DateTime.now

    Timecop.freeze(10.minutes.ago)
    @db.mark_failed(@track_3)

    Timecop.freeze(3.minutes.ago)
    @db.mark_synced(@track)

    Timecop.freeze(2.minutes.ago)
    @db.mark_synced(@track_2)

    Timecop.freeze(dummy_now)
    stale_tracks = @db.stale_tracks_before(2.seconds)
    assert_equal @track.id, stale_tracks.first[:track_id]
    assert_equal @track_2.id, stale_tracks.second[:track_id]
    assert_equal @track_3.id, stale_tracks.third[:track_id]
  end

  test "fetches stale tracks always returns failures if outside cool-off" do
    ts1 = 3.minutes.ago
    ts2 = 1.minutes.ago
    dummy_now = DateTime.now

    Timecop.freeze(10.seconds.ago)
    @db.mark_failed(@track)

    Timecop.freeze(1.minutes.ago)
    @db.mark_failed(@track_3)

    Timecop.freeze(10.minutes.ago)
    @db.mark_synced(@track_2)

    Timecop.freeze(dummy_now)
    # @track failure was less than 30 seconds ago so it should be omitted
    stale_tracks = @db.stale_tracks_before(5.minutes)
    assert_equal 2, stale_tracks.size
    assert_equal @track_2.id, stale_tracks.first[:track_id]
    assert_equal @track_3.id, stale_tracks.second[:track_id]
  end
end
