require_relative '../../test_helper'

class Git::SyncTracksTest < ActiveSupport::TestCase
  test "fetches problem specs" do
    repo = mock()
    repo.expects(:fetch!)
    Git::ProblemSpecifications.stubs(:head).returns(repo)

    Git::SyncTracks.([], stdout: StringIO.new, stderr: StringIO.new)
  end

  test "syncs tracks" do
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    track = create(:track)

    Git::SyncTrack.expects(:call).with(track)

    Git::SyncTracks.([track], stdout: StringIO.new, stderr: StringIO.new)
  end

  test "approves hello world exercises" do
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    exercise = create(:exercise, slug: "hello-world", auto_approve: false)

    Git::SyncTracks.([], stdout: StringIO.new, stderr: StringIO.new)

    exercise.reload

    assert exercise.auto_approve?
  end
end
