require 'test_helper'

class Git::FetchesUpdatedTracksTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "does not fetch an already fetched track update" do
    track_update = create(:track_update)
    host_name = "host-1"
    track_update_fetch = create(:track_update_fetch,
                                track_update: track_update,
                                host: host_name)
    Socket.stubs(:gethostname).returns(host_name)

    assert_no_enqueued_jobs do
      Git::FetchesUpdatedTracks.fetch
    end
  end

  test "does not fetch an already synced track update" do
    track_update = create(:track_update, synced_at: Time.current)

    assert_no_enqueued_jobs do
      Git::FetchesUpdatedTracks.fetch
    end
  end

  test "does not fetch an already synced track update with previous fetches" do
    track_update = create(:track_update, synced_at: Time.current)
    track_update_fetch = create(:track_update_fetch,
                                track_update: track_update,
                                host: "host-1")
    Socket.stubs(:gethostname).returns("host-2")

    assert_no_enqueued_jobs do
      Git::FetchesUpdatedTracks.fetch
    end
  end

  test "fetches a track update if no fetches by any host yet" do
    track_update = create(:track_update, track_update_fetches: [])

    assert_enqueued_with(job: FetchTrackUpdateJob, args: [track_update.id]) do
      Git::FetchesUpdatedTracks.fetch
    end
  end

  test "fetches a track update if not yet fetched by host" do
    track_update = create(:track_update, track_update_fetches: [])
    track_update_fetch = create(:track_update_fetch,
                         track_update: track_update,
                         host: "host-1")
    Socket.stubs(:gethostname).returns("host-2")

    assert_enqueued_with(job: FetchTrackUpdateJob, args: [track_update.id]) do
      Git::FetchesUpdatedTracks.fetch
    end
  end
end
