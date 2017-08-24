require 'test_helper'

class Git::SyncsUpdatedTracksTest < ActiveJob::TestCase
  test "syncs a fully fetched track update" do
    ENV["NUM_WEBSERVERS"] = "1"
    track_update = create(:track_update)
    create_list(:track_update_fetch,
                1,
                track_update: track_update,
                completed_at: Time.current)

    assert_enqueued_with(job: SyncTrackUpdateJob) do
      Git::SyncsUpdatedTracks.sync
    end

    ENV["NUM_WEBSERVERS"] = nil
  end

  test "does not sync an unfetched track update" do
    ENV["NUM_WEBSERVERS"] = "1"
    track_update = create(:track_update)
    create_list(:track_update_fetch,
                1,
                track_update: track_update,
                completed_at: nil)

    assert_no_enqueued_jobs do
      Git::SyncsUpdatedTracks.sync
    end

    ENV["NUM_WEBSERVERS"] = nil
  end

  test "does not sync a track update not fetched by all webservers" do
    ENV["NUM_WEBSERVERS"] = "2"
    track_update = create(:track_update)
    create_list(:track_update_fetch,
                1,
                track_update: track_update,
                completed_at: Time.current)

    assert_no_enqueued_jobs do
      Git::SyncsUpdatedTracks.sync
    end

    ENV["NUM_WEBSERVERS"] = nil
  end

  test "does not sync a synced track update" do
    ENV["NUM_WEBSERVERS"] = "1"
    track_update = create(:track_update, synced_at: Time.current)
    create_list(:track_update_fetch,
                1,
                track_update: track_update,
                completed_at: Time.current)

    assert_no_enqueued_jobs do
      Git::SyncsUpdatedTracks.sync
    end

    ENV["NUM_WEBSERVERS"] = nil
  end
end
