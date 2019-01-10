require 'test_helper'

class SyncRepoUpdateJobTest < ActiveJob::TestCase
  test "fetches tracks" do
    track = create(:track, slug: "ruby")
    repo_update = create(:repo_update, slug: "ruby")
    Git::SyncTracks.stubs(:call)

    Git::FetchRepo.expects(:call).with(repo_update.repo)

    SyncRepoUpdateJob.perform_now(repo_update.id)
  end

  test "syncs tracks" do
    track = create(:track, slug: "ruby")
    repo_update = create(:repo_update, slug: "ruby")
    Git::FetchRepo.stubs(:call)

    Git::SyncTracks.expects(:call).with([track])

    SyncRepoUpdateJob.perform_now(repo_update.id)
  end

  test "syncs website-copy repo" do
    repo_update = create(:repo_update, slug: "website-copy")
    Git::FetchRepo.stubs(:call)
    Git::SyncWebsiteCopy.expects(:call)

    SyncRepoUpdateJob.perform_now(repo_update.id)
  end

  test "syncs blog repo" do
    repo_update = create(:repo_update, slug: "blog")
    Git::FetchRepo.stubs(:call)
    Git::SyncBlogPosts.expects(:call)

    SyncRepoUpdateJob.perform_now(repo_update.id)
  end


  test "does not sync unregistered repos" do
    repo_update = create(:repo_update, slug: "problem-specifications")
    Git::FetchRepo.stubs(:call)

    Git::SyncTracks.expects(:call).never

    SyncRepoUpdateJob.perform_now(repo_update.id)
  end

  test "records sync time after performing" do
    repo_update = create(:repo_update, slug: "website-copy")
    Git::SyncWebsiteCopy.stubs(:call)
    Git::FetchRepo.stubs(:call)

    SyncRepoUpdateJob.perform_now(repo_update.id)

    repo_update.reload
    refute_nil repo_update.synced_at
  end
end
