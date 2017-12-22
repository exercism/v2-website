class Git::FetchesRepos
  FETCH_BACKOFF_PERIOD = 1.second

  def self.fetch(repos)
    new(repos).fetch
  end

  def initialize(repos)
    @repos = repos
  end

  def fetch
    repos.each do |repo|
      Git::FetchesRepo.fetch(repo)
      sleep FETCH_BACKOFF_PERIOD
    end
  end

  private
  attr_reader :repos
end
