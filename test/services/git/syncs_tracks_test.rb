require 'test_helper'

class Git::SyncsTracksTest < ActiveSupport::TestCase
  test "fetches problem specs" do
    repo = mock()
    repo.expects(:fetch!)
    Git::ProblemSpecifications.stubs(:head).returns(repo)

    Git::SyncsTracks.sync([])
  end

  test "syncs tracks" do
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    track = create(:track)

    Git::SyncsTrack.expects(:sync!).with(track)

    Git::SyncsTracks.sync([track])
  end

  test "approves hello world exercises" do
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    exercise = create(:exercise, slug: "hello-world", auto_approve: false)

    Git::SyncsTracks.sync([])

    exercise.reload

    assert exercise.auto_approve?
  end
end
