require_relative '../../test_helper'

class Git::SeedsTracksTest < ActiveSupport::TestCase
  test "seeds tracks" do
    track = create(:track)
    exercise = create(:exercise, slug: "hello-world", track: track)
    Git::SeedTracks.stubs(:tracks).returns([nil])

    Git::SeedTrack.expects(:call).with(nil)
    Git::FetchRepo.expects(:call).with(track.repo)
    Git::SyncTrack.expects(:call).with(track)

    Git::SeedTracks.(stdout: StringIO.new, stderr: StringIO.new)

    exercise.reload
    assert exercise.auto_approve?
  end
end
