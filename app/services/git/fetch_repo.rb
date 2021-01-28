class Git::FetchRepo
  include Mandate

  ERROR_BACKOFF_PERIOD = 10.seconds

  initialize_with :repo

  def call
    return
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
