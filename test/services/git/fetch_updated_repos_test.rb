require 'test_helper'

class Git::FetchUpdatedReposTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "does not fetch an already fetched repo update" do
    repo_update = create(:repo_update)
    host_name = "host-1"
    repo_update_fetch = create(:repo_update_fetch,
                                repo_update: repo_update,
                                host: host_name)
    create(:repo_update_fetch,
           repo_update: repo_update,
           host: "host-2")
    ClusterConfig.stubs(:server_identity).returns(host_name)

    FetchRepoUpdateJob.expects(:perform_now).never

    Git::FetchUpdatedRepos.fetch
  end

  test "does not fetch an already synced repo update" do
    repo_update = create(:repo_update, synced_at: Time.current)

    FetchRepoUpdateJob.expects(:perform_now).never

    Git::FetchUpdatedRepos.fetch
  end

  test "does not fetch an already synced repo update with previous fetches" do
    repo_update = create(:repo_update, synced_at: Time.current)
    repo_update_fetch = create(:repo_update_fetch,
                                repo_update: repo_update,
                                host: "host-1")
    ClusterConfig.stubs(:server_identity).returns("host-2")

    FetchRepoUpdateJob.expects(:perform_now).never

    Git::FetchUpdatedRepos.fetch
  end

  test "fetches a repo update if no fetches by any host yet" do
    repo_update = create(:repo_update, repo_update_fetches: [])

    FetchRepoUpdateJob.expects(:perform_now).with(repo_update.id)

    Git::FetchUpdatedRepos.fetch
  end

  test "fetches a repo update if not yet fetched by host" do
    repo_update = create(:repo_update, repo_update_fetches: [])
    repo_update_fetch = create(:repo_update_fetch,
                         repo_update: repo_update,
                         host: "host-1")
    ClusterConfig.stubs(:server_identity).returns("host-2")

    FetchRepoUpdateJob.expects(:perform_now).with(repo_update.id)

    Git::FetchUpdatedRepos.fetch
  end
end
