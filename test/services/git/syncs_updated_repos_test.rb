require_relative '../../test_helper'

class Git::SyncsUpdatedReposTest < ActiveJob::TestCase
  setup do
    fake_stdout = mock
    fake_stdout.stubs(:puts)
    Git::SyncsUpdatedRepos.any_instance.stubs(stdout: fake_stdout)
  end

  test "syncs a fully fetched track update" do
    ClusterConfig.stubs(:num_webservers).returns(2)
    repo_update = create(:repo_update)
    create_list(:repo_update_fetch,
                2,
                repo_update: repo_update,
                completed_at: Time.current)

    SyncRepoUpdateJob.expects(:perform_now).with(repo_update.id)

    Git::SyncsUpdatedRepos.sync(stdout: StringIO.new)
  end

  test "does not sync an unfetched track update" do
    ClusterConfig.stubs(:num_webservers).returns(1)
    repo_update = create(:repo_update)
    create_list(:repo_update_fetch,
                1,
                repo_update: repo_update,
                completed_at: nil)
    SyncRepoUpdateJob.expects(:perform_now).never

    Git::SyncsUpdatedRepos.sync
  end

  test "does not sync a track update not fetched by all webservers" do
    ClusterConfig.stubs(:num_webservers).returns(2)
    repo_update = create(:repo_update)
    create_list(:repo_update_fetch,
                1,
                repo_update: repo_update,
                completed_at: Time.current)
    SyncRepoUpdateJob.expects(:perform_now).never

    Git::SyncsUpdatedRepos.sync
  end

  test "does not sync a synced track update" do
    ClusterConfig.stubs(:num_webservers).returns(1)
    repo_update = create(:repo_update, synced_at: Time.current)
    create_list(:repo_update_fetch,
                1,
                repo_update: repo_update,
                completed_at: Time.current)
    SyncRepoUpdateJob.expects(:perform_now).never

    Git::SyncsUpdatedRepos.sync
  end
end
