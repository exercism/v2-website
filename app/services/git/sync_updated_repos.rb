class Git::SyncUpdatedRepos
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
      sleep QUIET_PERIOD
    end
  end

  def sync
    stdout.puts "Syncing outstanding repos"
    repo_updates.each do |update|
      begin
        SyncRepoUpdateJob.perform_now(update.id)
      rescue Octokit::TooManyRequests
        sleep(60.seconds)
        retry
      rescue => exception
        Bugsnag.notify(exception)
      end
    end
  end

  private

  attr_reader :repo_updates, :stdout

  def repo_updates
    RepoUpdate.
      joins(:repo_update_fetches).
      where(synced_at: nil).
      where.not(repo_update_fetches: { completed_at: nil }).
      group("repo_update_id").
      having("count(repo_update_id) = #{ClusterConfig.num_webservers}")
  end
end
