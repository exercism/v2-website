require 'test_helper'

class SyncTrackUpdateJobTest < ActiveJob::TestCase
  test "syncs a track update" do
    track_update = create(:track_update)

    Git::SyncsTracks.expects(:sync).with([track_update.track])

    SyncTrackUpdateJob.perform_now(track_update.id)
  end

  test "records sync time after performing" do
    Git::SyncsTracks.stubs(:sync)
    track_update = create(:track_update)

    SyncTrackUpdateJob.perform_now(track_update.id)

    track_update.reload
    refute_nil track_update.synced_at
  end
end
