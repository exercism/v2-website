require 'test_helper'

class SyncRepoUpdateJobTest < ActiveJob::TestCase
  test "syncs tracks" do
    track = create(:track, slug: "ruby")
    repo_update = create(:repo_update, slug: "ruby")

    Git::SyncsTracks.expects(:sync).with([track])

    SyncRepoUpdateJob.perform_now(repo_update.id)
  end

  test "does not sync non-tracks" do
    repo_update = create(:repo_update, slug: "website-copy")

    Git::SyncsTracks.expects(:sync).never

    SyncRepoUpdateJob.perform_now(repo_update.id)
  end

  test "records sync time after performing" do
    repo_update = create(:repo_update)

    SyncRepoUpdateJob.perform_now(repo_update.id)

    repo_update.reload
    refute_nil repo_update.synced_at
  end
end
