class Git::FetchesUpdatedRepos

  QUIET_PERIOD = 30.seconds

  def self.run
    new.run
  end

  def self.fetch
    new.fetch
  end

  def run
    loop do
      fetch
      sleep QUIET_PERIOD
    end
  end

  def fetch
    find_repo_update
    fetch_repo_update if repo_update
  end

  private

  attr_reader :repo_update, :repo_update_fetch

  def find_repo_update
    @repo_update = repo_updates_without_fetches || repo_updates_not_fetched
  end

  def repo_updates_without_fetches
    RepoUpdate.
      includes(:repo_update_fetches).
      where(synced_at: nil).
      find_by(repo_update_fetches: { repo_update_id: nil })
  end

  def repo_updates_not_fetched
    RepoUpdate.
      includes(:repo_update_fetches).
      where(synced_at: nil).
      where.not(repo_update_fetches: { host: ClusterConfig.server_identity }).
      first
  end

  def fetch_repo_update
    FetchRepoUpdateJob.perform_now(repo_update.id)
  end
end
