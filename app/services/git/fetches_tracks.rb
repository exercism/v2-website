class Git::FetchesTracks

  QUIET_PERIOD = 30.seconds
  ERROR_BACKOFF_PERIOD = 10.seconds

  def self.run
    new.run
  end

  def run
    loop do
      fetch_problem_specs
      fetch_website_content
      Track.find_each do |track|
        fetch(track)
        sleep 1.second
      end
      sleep QUIET_PERIOD
    end
  end

  private

  def fetch_problem_specs
    Rails.logger.info "Fetching problem specs"
    Git::ProblemSpecifications.head.fetch!
  rescue => e
    Rails.logger.error "Exception while problem specs"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace
    sleep ERROR_BACKOFF_PERIOD
  end

  def fetch_website_content
    Rails.logger.info "Fetching website content"
    Git::WebsiteContent.head.fetch!
  rescue => e
    Rails.logger.error "Exception while website content"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace
    sleep ERROR_BACKOFF_PERIOD
  end

  def fetch(track)
    repo_url = track.repo_url
    if repo_url.start_with?("http://example.com")
      Rails.logger.info "Skipping fetch for #{repo_url}"
    else
      Rails.logger.info "Fetching #{repo_url}"
      head_commit = Git::ExercismRepo.new(repo_url, auto_fetch: true).head
      Rails.logger.info "Done #{repo_url}. Current HEAD commit is #{head_commit}"
    end
  rescue => e
    Rails.logger.error "Exception while fetching track"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace
    sleep ERROR_BACKOFF_PERIOD
  end

end
