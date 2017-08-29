require 'test_helper'

class Git::FetchesUpdatedReposTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "does not fetch an already fetched repo update" do
    repo_update = create(:repo_update)
    host_name = "host-1"
    repo_update_fetch = create(:repo_update_fetch,
                                repo_update: repo_update,
                                host: host_name)
    ClusterConfig.stubs(:server_identity).returns(host_name)

    assert_no_enqueued_jobs do
      Git::FetchesUpdatedRepos.fetch
    end
  end

  test "does not fetch an already synced repo update" do
    repo_update = create(:repo_update, synced_at: Time.current)

    assert_no_enqueued_jobs do
      Git::FetchesUpdatedRepos.fetch
    end
  end

  test "does not fetch an already synced repo update with previous fetches" do
    repo_update = create(:repo_update, synced_at: Time.current)
    repo_update_fetch = create(:repo_update_fetch,
                                repo_update: repo_update,
                                host: "host-1")
    ClusterConfig.stubs(:server_identity).returns("host-2")

    assert_no_enqueued_jobs do
      Git::FetchesUpdatedRepos.fetch
    end
  end

  test "fetches a repo update if no fetches by any host yet" do
    repo_update = create(:repo_update, repo_update_fetches: [])

    assert_enqueued_with(job: FetchRepoUpdateJob, args: [repo_update.id]) do
      Git::FetchesUpdatedRepos.fetch
    end
  end

  test "fetches a repo update if not yet fetched by host" do
    repo_update = create(:repo_update, repo_update_fetches: [])
    repo_update_fetch = create(:repo_update_fetch,
                         repo_update: repo_update,
                         host: "host-1")
    ClusterConfig.stubs(:server_identity).returns("host-2")

    assert_enqueued_with(job: FetchRepoUpdateJob, args: [repo_update.id]) do
      Git::FetchesUpdatedRepos.fetch
    end
  end
end
