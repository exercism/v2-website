class Git::FetchesTracks

  QUIET_PERIOD = 10.seconds

  def self.run
    new.run
  end

  def run
    loop do
      Track.find_each do |track|
        fetch(track)
        sleep 1.second
      end
      sleep 1.second
    end
  end

  private

  def fetch(track)
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
    sleep QUIET_PERIOD
  end

end
