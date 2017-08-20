require 'test_helper'
 
class UpdateTrackJobTest < ActiveJob::TestCase
  test "fetches a track" do
    track = build_stubbed(:track)
    Git::SyncsTrack.stubs(:sync!)

    Git::FetchesTrack.expects(:fetch).with(track)

    UpdateTrackJob.perform_now(track)
  end

  test "syncs a track" do
    track = build_stubbed(:track)
    Git::FetchesTrack.stubs(:fetch)

    Git::SyncsTrack.expects(:sync!).with(track)

    UpdateTrackJob.perform_now(track)
  end

end
