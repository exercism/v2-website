class Git::FetchesTracks

  ERROR_BACKOFF_PERIOD = 10.seconds

  def self.fetch(tracks)
    new(tracks).fetch
  end

  def initialize(tracks)
    @tracks = tracks
  end

  def fetch
    fetch_problem_specs
    fetch_website_content
    tracks.each do |track|
      fetch_track(track)
      sleep 1.second
    end
  end

  private
  attr_reader :tracks

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

  def fetch_track(track)
    repo_url = track.repo_url
    if repo_url.start_with?("http://example.com")
      Rails.logger.info "Skipping fetch for #{repo_url}"
    else
      Rails.logger.info "Fetching #{repo_url}"
      repo = Git::ExercismRepo.new(repo_url)
      repo.fetch!
      head_commit = repo.head
      Rails.logger.info "Done #{repo_url}. Current HEAD commit is #{head_commit}"
    end
  rescue => e
    Rails.logger.error "Exception while fetching track"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace
    sleep ERROR_BACKOFF_PERIOD
  end

end
