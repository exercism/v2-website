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
    repo_updates.each { |update| FetchRepoUpdateJob.perform_now(update.id) }
  end

  private

  attr_reader :repo_update, :repo_update_fetch

  def repo_updates
    fetched = RepoUpdate.
      includes(:repo_update_fetches).
      where(repo_update_fetches: { host: ClusterConfig.server_identity })

    RepoUpdate.
      where(synced_at: nil).
      where.not(id: fetched.pluck(:id))
  end

  def fetch_repo_update
    FetchRepoUpdateJob.perform_now(repo_update.id)
  end
end
