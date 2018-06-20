class Git::SyncsUpdatedRepos
  QUIET_PERIOD = 10.seconds

  def self.run(stdout: STDOUT)
    new(stdout: stdout).run
  end

  def self.sync(stdout: STDOUT)
    new(stdout: stdout).sync
  end

  def initialize(stdout:)
    @stdout = stdout
  end

  def run
    loop do
      sync
      stdout.puts "Sleeping"
      sleep QUIET_PERIOD
    end
  end

  def sync
    find_repo_update
    if repo_update
      stdout.puts "Syncing outstanding repos"
      sync_repo_update
    end
  end

  private
  attr_reader :repo_update, :stdout

  def find_repo_update
    @repo_update = RepoUpdate.
      joins(:repo_update_fetches).
      where(synced_at: nil).
      where.not(repo_update_fetches: { completed_at: nil }).
      group("repo_update_id").
      having("count(repo_update_id) = #{ClusterConfig.num_webservers}").
      first
  end

  def sync_repo_update
    SyncRepoUpdateJob.perform_now(repo_update.id)
  end
end
