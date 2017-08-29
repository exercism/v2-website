require 'test_helper'

class FetchRepoUpdateJobTest < ActiveJob::TestCase
  test "records fetch before performing" do
    Git::FetchesRepos.stubs(:fetch)
    track = create(:track, slug: "ruby")
    repo_update = create(:repo_update, slug: "ruby")
    host_name = "host"
    ClusterConfig.stubs(:server_identity).returns(host_name)

    FetchRepoUpdateJob.perform_now(repo_update.id)

    repo_update_fetch = RepoUpdateFetch.last
    assert_equal host_name, repo_update_fetch.host
    assert_equal repo_update, repo_update_fetch.repo_update
  end

  test "fetches a repo update" do
    track = create(:track, slug: "ruby")
    repo_update = create(:repo_update, slug: "ruby")

    Git::FetchesRepos.expects(:fetch).with([repo_update.repo])

    FetchRepoUpdateJob.perform_now(repo_update.id)
  end

  test "records fetch completion time after performing" do
    Git::FetchesRepos.stubs(:fetch)
    track = create(:track, slug: "ruby")
    repo_update = create(:repo_update, slug: "ruby")
    host_name = "host"
    ClusterConfig.stubs(:server_identity).returns(host_name)

    FetchRepoUpdateJob.perform_now(repo_update.id)

    repo_update_fetch = RepoUpdateFetch.last
    refute_nil repo_update_fetch.completed_at
  end
end
