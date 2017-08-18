require 'test_helper'
 
class UpdateTracksJobTest < ActiveJob::TestCase
  test "calls Git::SyncsTracks" do
    Git::FetchesTracks.stubs(:run)
    Git::SyncsTracks.expects(:sync)

    UpdateTracksJob.perform_now
  end

  test "calls Git::FetchesTracks" do
    Git::SyncsTracks.stubs(:sync)
    Git::FetchesTracks.expects(:run)

    UpdateTracksJob.perform_now
  end
end
