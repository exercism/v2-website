require_relative '../../test_helper'

class Git::SeedsTracksTest < ActiveSupport::TestCase
  test "seeds tracks" do
    track = create(:track)
    exercise = create(:exercise, slug: "hello-world", track: track)
    Git::SeedsTracks.stubs(:tracks).returns([nil])

    Git::SeedsTrack.expects(:seed!).with(nil)
    Git::FetchesRepo.expects(:fetch).with(track.repo)
    Git::SyncsTrack.expects(:sync!).with(track)

    Git::SeedsTracks.seed!(stdout: StringIO.new, stderr: StringIO.new)

    exercise.reload
    assert exercise.auto_approve?
  end
end
