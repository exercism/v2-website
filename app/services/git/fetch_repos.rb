class Git::FetchRepos
  include Mandate

  FETCH_BACKOFF_PERIOD = 1.second

  initialize_with(:repos)

  def call
    repos.each do |repo|
      Git::FetchRepo.(repo)
      sleep FETCH_BACKOFF_PERIOD
    end
  end
end
