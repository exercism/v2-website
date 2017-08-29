class Git::FetchesRepos

  ERROR_BACKOFF_PERIOD = 10.seconds
  FETCH_BACKOFF_PERIOD = 1.second

  def self.fetch(repos)
    new(repos).fetch
  end

  def initialize(repos)
    @repos = repos
  end

  def fetch
    repos.each do |repo|
      fetch_repo(repo)
      sleep FETCH_BACKOFF_PERIOD
    end
  end

  private
  attr_reader :repos

  def fetch_repo(repo)
    Rails.logger.info "Fetching #{repo.repo_url}"
    repo.fetch!
    Rails.logger.info "Done #{repo.repo_url}. Current HEAD commit is #{repo.head}"
  rescue => e
    Rails.logger.error "Exception while fetching repo"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace
    sleep ERROR_BACKOFF_PERIOD
  end
end
