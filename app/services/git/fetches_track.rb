class Git::FetchesTrack
  def self.fetch(track)
    new(track).fetch
  end

  def initialize(track)
    @track = track
  end

  def fetch
    fetch_problem_specs
    fetch_website_content
    fetch_track(track)
  end

  private

  attr_reader :track

  def fetch_problem_specs
    Git::ProblemSpecifications.head.fetch!
  end

  def fetch_website_content
    Git::WebsiteContent.head.fetch!
  end

  def fetch_track(track)
    repo_url = track.repo_url

    if repo_url.start_with?("http://example.com")
      puts "Skipping fetch for #{repo_url}"
    else
      puts "Fetching #{repo_url}"
      Git::ExercismRepo.new(repo_url, auto_fetch: true)
    end
  rescue => e
    puts e.message
    puts e.backtrace
  end
end
