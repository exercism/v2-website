require_relative '../../test_helper'

class Git::SyncsUpdatedReposTest < ActiveJob::TestCase
  test "syncs a fully fetched track update" do
    ClusterConfig.stubs(:num_webservers).returns(2)
    repo_update = create(:repo_update)
    create_list(:repo_update_fetch,
                2,
                repo_update: repo_update,
                completed_at: Time.current)

    assert_enqueued_with(job: SyncRepoUpdateJob) do
      Git::SyncsUpdatedRepos.sync
    end
  end

  test "does not sync an unfetched track update" do
    ClusterConfig.stubs(:num_webservers).returns(1)
    repo_update = create(:repo_update)
    create_list(:repo_update_fetch,
                1,
                repo_update: repo_update,
                completed_at: nil)

    assert_no_enqueued_jobs do
      Git::SyncsUpdatedRepos.sync
    end
  end

  test "does not sync a track update not fetched by all webservers" do
    ClusterConfig.stubs(:num_webservers).returns(2)
    repo_update = create(:repo_update)
    create_list(:repo_update_fetch,
                1,
                repo_update: repo_update,
                completed_at: Time.current)

    assert_no_enqueued_jobs do
      Git::SyncsUpdatedRepos.sync
    end
  end

  test "does not sync a synced track update" do
    ClusterConfig.stubs(:num_webservers).returns(1)
    repo_update = create(:repo_update, synced_at: Time.current)
    create_list(:repo_update_fetch,
                1,
                repo_update: repo_update,
                completed_at: Time.current)

    assert_no_enqueued_jobs do
      Git::SyncsUpdatedRepos.sync
    end
  end
end
