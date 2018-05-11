require_relative '../../test_helper'

class Git::SyncsTracksTest < ActiveSupport::TestCase
  test "fetches problem specs" do
    repo = mock()
    repo.expects(:fetch!)
    Git::ProblemSpecifications.stubs(:head).returns(repo)

    Git::SyncsTracks.sync([], stdout: StringIO.new, stderr: StringIO.new)
  end

  test "syncs tracks" do
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    track = create(:track)

    Git::SyncsTrack.expects(:sync!).with(track)

    Git::SyncsTracks.sync([track], stdout: StringIO.new, stderr: StringIO.new)
  end

  test "approves hello world exercises" do
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    exercise = create(:exercise, slug: "hello-world", auto_approve: false)

    Git::SyncsTracks.sync([], stdout: StringIO.new, stderr: StringIO.new)

    exercise.reload

    assert exercise.auto_approve?
  end
end
