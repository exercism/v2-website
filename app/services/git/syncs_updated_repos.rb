class Git::SyncsUpdatedRepos
  QUIET_PERIOD = 10.seconds

  def self.run
    new.run
  end

  def self.sync
    new.sync
  end

  def run
    loop do
      sync
      puts "Sleeping"
      sleep QUIET_PERIOD
    end
  end

  def sync
    find_repo_update
    if repo_update
      puts "Syncing outstanding repos"
      sync_repo_update
    end
  end

  private
  attr_reader :repo_update

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
    SyncRepoUpdateJob.perform_later(repo_update.id)
  end
end
