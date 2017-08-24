require 'test_helper'

class FetchTrackUpdateJobTest < ActiveJob::TestCase
  test "records fetch before performing" do
    Git::FetchesTracks.stubs(:fetch)
    track_update = create(:track_update)
    host_name = "host"
    Socket.stubs(:gethostname).returns(host_name)

    FetchTrackUpdateJob.perform_now(track_update.id)

    track_update_fetch = TrackUpdateFetch.last
    assert_equal host_name, track_update_fetch.host
    assert_equal track_update, track_update_fetch.track_update
  end

  test "fetches a track update" do
    track_update = create(:track_update)

    Git::FetchesTracks.expects(:fetch).with([track_update.track])

    FetchTrackUpdateJob.perform_now(track_update.id)
  end

  test "records fetch completion time after performing" do
    Git::FetchesTracks.stubs(:fetch)
    track_update = create(:track_update)
    host_name = "host"
    Socket.stubs(:gethostname).returns(host_name)

    FetchTrackUpdateJob.perform_now(track_update.id)

    track_update_fetch = TrackUpdateFetch.last
    refute_nil track_update_fetch.completed_at
  end
end
